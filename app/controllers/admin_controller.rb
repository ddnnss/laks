class AdminController < ApplicationController
  before_action :getmenu, :getcart
  def getmenu
    @cat_all = Category.all
    @menu_cat = Category.where(show_in_menu: true)
  end
  def getcart
    if session[:active]
    else
      if session[:cart].nil?
        session[:total] = 0
      else
        session[:total] = 0
        @cart= Item.find(session[:cart])
      end

    end
  end
  def items
    @maincat = Category.where(cat_main: true)

  end
  def categories
    @maincat = Category.all

  end
  def addnewitem
    if params[:type] == 'getcoll'
      colls = Hash.new
      coll = Collection.all
      coll.each do |cc|
        colls[cc.id] = cc.collection_name
      end

      respond_to do |format|

        @coll_sel = colls
        @subcat_id = params[:id]

        format.js
      end

    end
    if params[:type] == 'save'
    newitem = Item.new
    newitem.subcategory_id = params[:subcat_id]
    newitem.item_name = params[:addnewitem][:item_name]
    newitem.item_name_translit = Translit.convert(params[:addnewitem][:item_name].gsub(' ','-'), :english)
    newitem.item_name_caps = params[:addnewitem][:item_name].mb_chars.upcase
    newitem.item_page_title = params[:addnewitem][:item_page_title]
    newitem.item_page_description = params[:addnewitem][:item_page_description]
    newitem.item_description = params[:item_description]
    newitem.item_price = params[:item_price].to_i
    newitem.item_opt_price = params[:item_opt_price].to_i
    newitem.item_opt_price_count = params[:item_opt_price_count].to_i
    newitem.item_tags = params[:item_tags]

    if params[:addnewitem][:item_weight] != ''
      newitem.item_weight = params[:addnewitem][:item_weight]
    end
    if params[:addnewitem][:item_size] != ''
      newitem.item_size = params[:addnewitem][:item_size]
    end
    if params[:addnewitem][:item_article] != ''
      newitem.item_article = params[:addnewitem][:item_article]
    end


    if params[:item_new] == '1'
      newitem.item_new = true
    end
    if params[:item_discount] == '1'
      newitem.item_discount = params[:item_discount_val].to_i
    end
    if params[:add_coll] == 'on'
      newitem.collection_id = params[:collections_select]

    end
    newitem.save

    Dir.mkdir('public/images/items/' + newitem.id.to_s)
    uploadedFile1 = params[:addnewitem][:item_image1]
    File.open(Rails.root.join('public','images','items', newitem.id.to_s, uploadedFile1.original_filename), 'wb' ) do |f|
      f.write(uploadedFile1.read)
    end
    newitem.update_column(:item_image1,uploadedFile1.original_filename)
    if params[:addnewitem][:item_image2].present?
      uploadedFile2 = params[:addnewitem][:item_image2]
      File.open(Rails.root.join('public','images','items', newitem.id.to_s, uploadedFile2.original_filename), 'wb' ) do |f|
        f.write(uploadedFile2.read)
      end
      newitem.update_column(:item_image2,uploadedFile2.original_filename)
    end

    if params[:addnewitem][:item_image3].present?
      uploadedFile3 = params[:addnewitem][:item_image3]
      File.open(Rails.root.join('public','images','items', newitem.id.to_s, uploadedFile3.original_filename), 'wb' ) do |f|
        f.write(uploadedFile3.read)
      end
      newitem.update_column(:item_image3,uploadedFile3.original_filename)
    end

    if params[:addnewitem][:item_image4].present?
      uploadedFile4 = params[:addnewitem][:item_image4]
      File.open(Rails.root.join('public','images','items', newitem.id.to_s, uploadedFile4.original_filename), 'wb' ) do |f|
        f.write(uploadedFile4.read)
      end
      newitem.update_column(:item_image4,uploadedFile4.original_filename)
    end
    redirect_to :controller => 'admin', :action => 'categories'
  end

  end

  def addnewcategory
    if params[:action_type] == 'new'
    newcat = Category.new
    newcat.cat_name = params[:addnewcategory][:maincat_name]
    newcat.cat_name_translit = Translit.convert(params[:addnewcategory][:maincat_name].gsub(' ','-'), :english)
    newcat.cat_page_title = params[:addnewcategory][:maincat_page_title]
    newcat.cat_page_description = params[:addnewcategory][:maincat_page_description]
    newcat.cat_description = params[:maincat_description]
    if params[:show_in_menu] == 'on'
      newcat.show_in_menu = true
    end
    uploadedFile = params[:addnewcategory][:maincat_image]
    if File.file?(Rails.root.join('public','images','maincategory', uploadedFile.original_filename))
      uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
    end

    File.open(Rails.root.join('public','images','maincategory', uploadedFile.original_filename), 'wb' ) do |f|
      f.write(uploadedFile.read)
    end
    newcat.cat_image = uploadedFile.original_filename
    newcat.save
    redirect_to :controller => 'admin', :action => 'categories'
    end
    if params[:action_type] == 'edit'
      newcat = Category.find(params[:maincat_id])
      newcat.update_column(:cat_name, params[:addnewcategory][:maincat_name])
      newcat.update_column(:cat_name_translit , Translit.convert(params[:addnewcategory][:maincat_name].gsub(' ','-'), :english))
      newcat.update_column(:cat_page_title, params[:addnewcategory][:maincat_page_title])
      newcat.update_column(:cat_page_description , params[:addnewcategory][:maincat_page_description])
      newcat.update_column(:cat_description , params[:maincat_description])
      if params[:show_in_menu] == 'on'
        newcat.update_column(:show_in_menu , true)
      else
        newcat.update_column(:show_in_menu , false)
      end
          if params[:addnewcategory][:maincat_image].present?
            uploadedFile = params[:addnewcategory][:maincat_image]
            if File.file?(Rails.root.join('public','images','maincategory', uploadedFile.original_filename))
              uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
            end
            File.open(Rails.root.join('public','images','maincategory', uploadedFile.original_filename), 'wb' ) do |f|
              f.write(uploadedFile.read)
            end
            newcat.update_column(:cat_image , uploadedFile.original_filename)
          end
      redirect_to :controller => 'admin', :action => 'categories'
    end


  end
  def addnewsubcategory
    if params[:action_type] == 'new'
    newcat = Subcategory.new
    newcat.category_id = params[:cat_id]
    newcat.subcat_name = params[:addnewsubcategory][:subcat_name]
    newcat.subcat_name_translit = Translit.convert(params[:addnewsubcategory][:subcat_name].gsub(' ','-'), :english)
    newcat.subcat_page_title = params[:addnewsubcategory][:subcat_page_title]
    newcat.subcat_page_description = params[:addnewsubcategory][:subcat_page_description]
    newcat.subcat_description = params[:subcat_description]
    uploadedFile = params[:addnewsubcategory][:subcat_image]
    if File.file?(Rails.root.join('public','images','subcategory', uploadedFile.original_filename))
      uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
    end
    File.open(Rails.root.join('public','images','subcategory',uploadedFile.original_filename), 'wb' ) do |f|
      f.write(uploadedFile.read)
    end
    newcat.subcat_image = uploadedFile.original_filename
    newcat.save
    redirect_to :controller => 'admin', :action => 'categories'
    end

    if params[:action_type] == 'edit'
      newcat = Subcategory.find(params[:subcat_id])
     # newcat.category_id = params[:cat_id]
      if params[:cat_remove] == 'on'
        newcat.update_column(:category_id,params[:maincat_select])
      end
      newcat.update_column(:subcat_name , params[:addnewsubcategory][:subcat_name])
      newcat.update_column(:subcat_name_translit , Translit.convert(params[:addnewsubcategory][:subcat_name].gsub(' ','-'), :english))
      newcat.update_column(:subcat_page_title , params[:addnewsubcategory][:subcat_page_title])
      newcat.update_column(:subcat_page_description , params[:addnewsubcategory][:subcat_page_description])
      newcat.update_column(:subcat_description,params[:subcat_description])
      if params[:addnewsubcategory][:subcat_image].present?
      uploadedFile = params[:addnewsubcategory][:subcat_image]
      if File.file?(Rails.root.join('public','images','subcategory', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end
      File.open(Rails.root.join('public','images','subcategory',uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      newcat.update_column(:subcat_image , uploadedFile.original_filename)
      end
      redirect_to :controller => 'admin', :action => 'categories'
    end
  end
  def deletecategory
    if params[:type] == 'main'
    Category.destroy(params[:id])

    else
      Subcategory.destroy(params[:id])

    end
    redirect_to :controller => 'admin', :action => 'categories'
  end

  def editcategory
    if params[:main] == '1'
      cat = Category.find(params[:cat_id])
      respond_to do |format|
        @cat_name = cat.cat_name
        @cat_image = cat.cat_image
        @cat_page_title = cat.cat_page_title
        @cat_page_description = cat.cat_page_description
        @cat_description = cat.cat_description.html_safe
        if cat.show_in_menu
        @cat_show_in_menu = '1'
        end
        @cat_id = params[:cat_id]
        @cat_main = '1'
        format.js
      end

    end
    if params[:main] == '0'
      cats = Hash.new
      cat = Subcategory.find(params[:cat_id])
      maincat = Category.all
      maincat.each do |mm|
        cats[mm.id] = mm.cat_name
      end

      respond_to do |format|
        @subcat_name = cat.subcat_name
        @subcat_image = cat.subcat_image
        @subcat_page_title = cat.subcat_page_title
        @subcat_page_description = cat.subcat_page_description
        @subcat_description = cat.subcat_description.html_safe
        @subcat_id = params[:cat_id]
        @maincat_sel = cats
        @cat_main = '0'
        format.js
      end
    end
  end

  def collections
    @collections = Collection.all
  end
  def addcollection
    if params[:action_type] == 'new'
      newcoll = Collection.new
      newcoll.collection_name = params[:addcollection][:collection_name]
      newcoll.collection_name_translit = Translit.convert(params[:addcollection][:collection_name]).gsub(' ','-')
      newcoll.collection_page_title = params[:addcollection][:collection_page_title]
      newcoll.collection_page_description = params[:addcollection][:collection_page_description]
      newcoll.collection_description = params[:collection_description]
      uploadedFile = params[:addcollection][:collection_image]
      if File.file?(Rails.root.join('public','images','collections', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end

      File.open(Rails.root.join('public','images','collections', uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      newcoll.collection_image = uploadedFile.original_filename
      newcoll.save
      redirect_to :controller => 'admin', :action => 'collections'
    end
    if params[:action_type] == 'edit'
      newcoll = Collection.find(params[:collection_id])
      newcoll.update_column(:collection_name , params[:addcollection][:collection_name])
      newcoll.update_column(:collection_name_translit , Translit.convert(params[:addcollection][:collection_name]).gsub(' ','-'))
      newcoll.update_column(:collection_page_title , params[:addcollection][:collection_page_title])
      newcoll.update_column(:collection_page_description , params[:addcollection][:collection_page_description])
      newcoll.update_column(:collection_description , params[:collection_description])
      uploadedFile = params[:addcollection][:collection_image]
      if File.file?(Rails.root.join('public','images','collections', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end

      File.open(Rails.root.join('public','images','collections', uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      newcoll.update_column(:collection_image , uploadedFile.original_filename)

      redirect_to :controller => 'admin', :action => 'collections'
    end

  end
  def editcollection
    coll = Collection.find(params[:collection_id])
    respond_to do |format|
      @collection_name = coll.collection_name
      @collection_image = coll.collection_image
      @collection_page_title = coll.collection_page_title
      @collection_page_description = coll.collection_page_description
      @collection_description = coll.collection_description.html_safe
      @collection_id = params[:collection_id]

      format.js
    end
  end
  def add2collection

  end
end
