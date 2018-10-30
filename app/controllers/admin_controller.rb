class AdminController < ApplicationController
  before_action :getmenu, :getcart, :ch_admin

  def ch_admin
    if client_admin
      return true
    else
      redirect_to '/'
    end
  end


  def deleteorder
    o = Order.find(params[:id])
    o.destroy
    redirect_to '/admin/orders'
  end
  def deleteclient
    c = Client.find(params[:id])
    c.destroy
    redirect_to '/admin/clients'
  end
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
        @cart= Item.find(session[:cart].keys)
      end

    end
  end
def index

end

  def itemchange
  params[:show_items].split(',').each do |i|
    unless params[:item_new].present?
      params[:item_new] = '0'
    end
    unless params[:item_pres].present?
      params[:item_pres] = '0'
    end
    item=Item.find_by_id(i)
    if params[:item_new].include? i
      item.update_column(:item_new,true)
    else
      item.update_column(:item_new,false)
    end
    if params[:item_pres].include? i
      item.update_column(:item_presents,true)
    else
      item.update_column(:item_presents,false)
    end

  end
  redirect_to '/admin/showsubcategory?subcat_id=' + params[:sub_id]


  end

  def clients
    @clients_active = 'active'
    @clients = Client.all
  end
  def clientinfo

    @client = Client.find(params[:client_id])
    @cl_orders=@client.orders
    if params[:client_action]=='update'
      @client.update_column(:client_name,params[:client_name])
      @client.update_column(:client_family,params[:client_family])
      @client.update_column(:client_ot4estvo,params[:client_ot4estvo])
      @client.update_column(:client_passport,params[:client_passport])
      @client.update_column(:client_comment,params[:client_comment])
      @client.update_column(:client_phone,params[:client_phone])
      @client.update_column(:client_email,params[:client_email])
      @client.update_column(:client_country,params[:client_country])
      @client.update_column(:client_city,params[:client_city])
      @client.update_column(:client_post_code,params[:client_post_code])
      @client.update_column(:client_address,params[:client_address])
      @client.update_column(:client_password,params[:client_password])

      if params[:client_vip].present?
        @client.update_column(:client_vip,true)
      else
        @client.update_column(:client_vip,false)
      end

      redirect_to '/admin/clientinfo?client_id=' + @client.id.to_s


    end

  end
  def orders
    if params[:order_id].present?
      o = Order.find(params[:order_id])
      o.update_column(:order_status ,params[:order_status])
    end
    @order_active = 'active'
    @orders=Order.all
  end

  def sendmail
    @sendmail = 'active'
    @mails = Sendmail.all

  end

  def savemail
    if params[:act] == 'update'
          m = Sendmail.find(params[:mail_id])
          m.update_column(:mail_subject,params[:mail_name])
          m.update_column(:mail_text,params[:mail_text])
    end
    if params[:act] ==  'delete'
          m = Sendmail.find(params[:mail_id])
          m.destroy
    end

    if params[:act] ==  'new'
      m = Sendmail.new
      m.mail_subject = params[:mail_name]
      m.mail_text = params[:mail_text]
      m.save
    end

    redirect_to '/admin/sendmail'


  end

  def editmail
    @mail = Sendmail.find(params[:mail_id])
  end
  def sendmailaction
    MailerMailer.sendmails('greshnik.im@gmail.com',params[:mail_text],'Тестовая рассылка').deliver_later
  end
  def order_info
    @order_active = 'active'
    @order = Order.find(params[:order_id])
    @order_items = Item.where(id: @order.order_items.keys)
    if @order.client_id == 0
        @order_guest = true
      else
        @order_guest = false
        @customer = Client.find(@order.client_id)
    end
    case @order.order_dostavka
          when '1'
            @order_dostavka = 'Курьерская доставка'
          when '2'
            @order_dostavka = 'Самовывоз'
          when '3'
            @order_dostavka = 'Транспортная компания'
    end
    case @order.order_oplata
      when '1'
        @order_oplata = 'Оплата при доставке'
      when '2'
        @order_oplata = 'Расчетный счет'
      when '3'
        @order_oplata = 'Оплата банковской картой'
    end
  ##  summ = 0
  ##  @order_items.each do |i|
   ##   summ = summ + i.item_opt_price * @order.order_items[i.id.to_s]
   ##   logger.info ('Стоимость заказа :' + summ.to_s)
   ## end
  ##  if summ > 5000
  ##    @order_opt_price = true
  ##  else
      @order_opt_price = false
  ##  end
    if @order.order_discount_code.nil?
      @order_discount = false
    else
      @order_discount = true
      @order_discount_code = @order.order_discount_code.split(',')[0]
      @order_discount_value = @order.order_discount_code.split(',')[1]
    end


  end
  def deleteitem
    i = Item.find(params[:item_id])
    i.destroy!
    redirect_to '/admin/items'
  end

  def delimg
    i = Item.find(params[:item_id])
    case params[:img]
      when '2'
        i.update_column(:item_image2 ,'none')
      when '3'
        i.update_column(:item_image3 ,'none')
      when '4'
        i.update_column(:item_image4 ,'none')
    end

    respond_to do |format|
      @img = params[:img]
      format.js
    end
  end
  def edititem
    if params[:type].present? && params[:type] == 'save'
      i = Item.find(params[:item_id])

      i.update_column(:item_name, params[:item_name])
      i.update_column(:item_name_translit, Translit.convert(params[:item_name].gsub(' ','-'), :english))
      i.update_column(:item_name_caps, params[:item_name].mb_chars.upcase)
      i.update_column(:item_page_title, params[:item_page_title])
      i.update_column(:item_page_description, params[:item_page_description])
      i.update_column(:item_description, params[:item_description])
      i.update_column(:item_opt_price, params[:item_opt_price].to_i)
      i.update_column(:item_opt_price, params[:item_opt_price].to_i)
    ##  i.update_column(:item_opt_price_count, params[:item_opt_price_count].to_i)
      i.update_column(:item_postavshik, params[:item_postavshik])

      i.update_column(:aktion_id, 0)
      i.update_column(:collection_id, 0)
      i.update_column(:item_new , false)
      i.update_column(:item_discount, 0)
      i.update_column(:item_in_sale, false)

      unless params[:item_comment]==''
      i.update_column(:item_comment, params[:item_comment])
      end

      unless params[:item_presents].present?
        i.update_column(:item_presents , false)
      end
      if params[:item_replace].present?
        i.update_column(:subcategory_id,params[:subcat_id])
        i.update_column(:item_filter , '')


      end

      if params[:item_weight] != ''
        i.update_column(:item_weight, params[:item_weight])
      else
        i.update_column(:item_weight, '')
      end
      if params[:item_size_d] != ''
        i.update_column(:item_size_d , params[:item_size_d])
      else
        i.update_column(:item_size_d , '')
      end
      if params[:item_size] != ''
        i.update_column(:item_size_sh , params[:item_size_sh])
      else
        i.update_column(:item_size_sh , '')
      end
      if params[:item_size_v] != ''
        i.update_column(:item_size_v , params[:item_size_v])
      else
        i.update_column(:item_size_v , '')
      end
      if params[:edititem][:item_filter] != ''
        i.update_column(:item_filter , params[:edititem][:item_filter][1..-1].join(','))
      else
        i.update_column(:item_filter , '')
      end
      if params[:item_kolvo] != ''
        i.update_column(:item_kolvo , params[:item_kolvo])
      else
        i.update_column(:item_kolvo , '')
      end
      if params[:item_material] != ''
        i.update_column(:item_material , params[:item_material])
      else
        i.update_column(:item_material , '')
      end
      if params[:item_article] != ''
        i.update_column(:item_article, params[:item_article])
      else
        i.update_column(:item_article, '')
      end
      if params[:item_color] != ''
        i.update_column(:item_color, params[:item_color])
      else
        i.update_column(:item_color, '')
      end


      if params[:item_new] == '1'
        i.update_column(:item_new , true)
      end
      if params[:item_discount] == '1'
        i.update_column(:item_discount, params[:item_discount_val].to_i)
        i.update_column(:item_in_sale, true)
      end
      if params[:add_coll] == 'on'
        i.update_column(:collection_id, params[:collections_select])
      end
      if params[:add_aktion] == 'on'
        i.update_column(:aktion_id, params[:aktion_select])
      end

      unless params[:edititem][:item_image1].blank?
      uploadedFile1 = params[:edititem][:item_image1]
      File.open(Rails.root.join('public','images','items', i.id.to_s, uploadedFile1.original_filename), 'wb' ) do |f|
        f.write(uploadedFile1.read)
      end

      i.update_column(:item_image1,uploadedFile1.original_filename)
    end
      unless params[:edititem][:item_image2].blank?
        uploadedFile2 = params[:edititem][:item_image2]
        File.open(Rails.root.join('public','images','items', i.id.to_s, uploadedFile2.original_filename), 'wb' ) do |f|
          f.write(uploadedFile2.read)
        end
        i.update_column(:item_image2,uploadedFile2.original_filename)
      end

      unless params[:edititem][:item_image3].blank?
        uploadedFile3 = params[:edititem][:item_image3]
        File.open(Rails.root.join('public','images','items', i.id.to_s, uploadedFile3.original_filename), 'wb' ) do |f|
          f.write(uploadedFile3.read)
        end
        i.update_column(:item_image3,uploadedFile3.original_filename)
      end

      unless params[:edititem][:item_image4].blank?
        uploadedFile4 = params[:edititem][:item_image4]
        File.open(Rails.root.join('public','images','items', i.id.to_s, uploadedFile4.original_filename), 'wb' ) do |f|
          f.write(uploadedFile4.read)
        end
        i.update_column(:item_image4,uploadedFile4.original_filename)
      end


redirect_to '/admin/showsubcategory?subcat_id=' + i.subcategory_id.to_s
    else
      @items_active = 'active'
      @item = Item.find(params[:item_id])
      @collections = Collection.all
      @tags = @item.subcategory.subcat_filter.split(",")
      @selected_tags = @item.item_filter.split(",")
      @aktion = Aktion.all
      @cat_main = Category.all
      @cat_sub = Subcategory.where(category_id: @cat_main.first.id)
end


  end
  def showsubcategory
    @subcat = Subcategory.find(params[:subcat_id])
    @tags = @subcat.subcat_filter.strip.split(',')
    @items_active = 'active'
    if params[:sort_type].present?
      case params[:sort_type]
        when '1'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_name desc')
        when '2'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_name asc')
        when '3'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_opt_price desc')
        when '4'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_opt_price asc')
        when '5'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_discount desc')
        when '6'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_discount asc')
        when '7'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('created_at desc')
      end
    else
      @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_name desc')
    end

    if params[:search]!='' && params[:search].present?
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).where('item_name_caps LIKE ?','%'+params[:search].mb_chars.upcase+'%')
    end
    if params[:article]!='' && params[:article].present?
      @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).where('item_article LIKE ?','%'+params[:article]+'%')
    end
    @collections = Collection.all
    @aktion = Aktion.all
    @show_items=''
    @items.each do |i|
      @show_items = @show_items + i.id.to_s + ','
    end
    @show_items = @show_items[0..-2]
  end

  def aktions
    @aktions_active = 'active'
    @aktions = Aktion.all
  end
  def items
    @items_active = 'active'
    @items = Item.all
    @cat_main = Category.all
    @cat_sub = Subcategory.where(category_id: @cat_main.first.id)
    @collections = Collection.all
    @aktion = Aktion.all

    if params[:sort_type].present?
      case params[:sort_type]
        when '1'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_name desc')
        when '2'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_name asc')
        when '3'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_opt_price desc')
        when '4'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_opt_price asc')
        when '5'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_discount desc')
        when '6'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_discount asc')
        when '7'
          @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('created_at desc')
      end
    else
      @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).order('item_name desc')
    end

    if params[:search]!='' && params[:search].present?
      @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).where('item_name_caps LIKE ?','%'+params[:search].mb_chars.upcase+'%')
    end
    if params[:article]!='' && params[:article].present?
      @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 15 ).where('item_article LIKE ?','%'+params[:article]+'%')
    end


  end

  def getsubcat
    subcats = Hash.new
    subcat = Subcategory.where(category_id: params[:cat_id])


    subcat.each do |mm|
      subcats[mm.id] = mm.subcat_name
    end

    respond_to do |format|

      @subcat_sel = subcats

      format.js
    end
  end



  def homepage
    @homepage_active = 'active'
    @slides = Slider.all
  end
  def addslide
    if params[:id].present?
      s = Slider.find(params[:id])
      s.destroy!
    else
      s= Slider.new
      s.slider_text1 = params[:addslide][:slide_text1]
      s.slider_text2 = params[:addslide][:slide_text2]
      s.slider_text3 = params[:addslide][:slide_text3]
      s.slider_url =   params[:addslide][:slide_url]
      uploadedFile = params[:addslide][:slide_image]
      if File.file?(Rails.root.join('public','images','slider', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end
      File.open(Rails.root.join('public','images','slider', uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      s.slider_image = uploadedFile.original_filename
      s.save
    end


    redirect_to request.referer


  end
  def discount
    @discount_active = 'active'
    @oneusediscounts = Discount.where(discount_for_one_use: true)
    @notoneusediscounts = Discount.where(discount_for_one_use: false)
    if params[:action_type] == 'generate_one'
      params[:discount][:discount_number].to_i.times do
        discount_new = Discount.new
        discount_new.discount_discount_value =  params[:discount][:discount_value]
        discount_new.discount_code = ('LA' + '-' + [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + '-' + [*('a'..'z'),*('0'..'9')].shuffle[0,4].join).upcase
        discount_new.discount_for_one_use = true
        discount_new.save
      end
      redirect_to admin_discount_path
    end

    if params[:action_type] == 'generate_notone'

        discount_new = Discount.new
        discount_new.discount_discount_value =  params[:discount][:discount_value]
        discount_new.discount_code = params[:discount][:discount_code]
        discount_new.discount_expiry = params[:discount_expiry]
        discount_new.discount_for_one_use = false
        discount_new.save

      redirect_to admin_discount_path
    end


  end

  def categories
    @category_active = 'active'
    @maincat = Category.all
    @aktion = Aktion.all

  end
  def addnewitem
    if params[:type] == 'getcoll'
      colls = Hash.new
      coll = Collection.all
      coll.each do |cc|
        colls[cc.id] = cc.collection_name
      end

      respond_to do |format|
        @action = 'getcoll'

        @coll_sel = colls
        @subcat_id = params[:id]

        format.js
      end

    end
    if params[:type] == 'save'
    newitem = Item.new
    newitem.subcategory_id = params[:subcat_id]
    newitem.item_name = params[:addnewitem][:item_name]
    newitem.item_name_translit = Translit.convert(params[:addnewitem][:item_name].gsub(' ','-').gsub('ь','').gsub('ъ','').gsub(/[?!*.,:;\/`"'#]/, ''), :english)
    newitem.item_name_caps = params[:addnewitem][:item_name].mb_chars.upcase
    newitem.item_page_title = params[:addnewitem][:item_page_title]
    newitem.item_page_description = params[:addnewitem][:item_page_description]
    newitem.item_description = params[:item_description]
    newitem.item_opt_price = params[:item_opt_price].to_i
    newitem.item_opt_price = params[:item_opt_price].to_i
  ##  newitem.item_opt_price_count = params[:item_opt_price_count].to_i
    newitem.item_postavshik = params[:item_postavshik]
    newitem.item_comment = params[:item_comment]
    newitem.aktion_id = 0
    newitem.collection_id = 0
    unless params[:item_presents].present?
      newitem.item_presents = false
    end

    if params[:addnewitem][:item_weight] != ''
      newitem.item_weight = params[:addnewitem][:item_weight]
    end

    if params[:addnewitem][:item_size_d] != ''
      newitem.item_size_d = params[:addnewitem][:item_size_d]
    end
    if params[:addnewitem][:item_size] != ''
      newitem.item_size_sh = params[:addnewitem][:item_size_sh]
    end
    if params[:addnewitem][:item_size_v] != ''
      newitem.item_size_v = params[:addnewitem][:item_size_v]
    end
    if params[:addnewitem][:item_filter] != ''
      newitem.item_filter = params[:addnewitem][:item_filter]*","
    end
    if params[:addnewitem][:item_kolvo] != ''
      newitem.item_kolvo = params[:addnewitem][:item_kolvo]
    end
    if params[:addnewitem][:item_material] != ''
      newitem.item_material = params[:addnewitem][:item_material]
    end

    if params[:addnewitem][:item_article] != ''
      newitem.item_article = params[:addnewitem][:item_article]
    end
    if params[:addnewitem][:item_color] != ''
      newitem.item_color = params[:addnewitem][:item_color]
    end


    if params[:item_new] == '1'
      newitem.item_new = true
    end
    if params[:item_discount] == '1'
      newitem.item_discount = params[:item_discount_val].to_i
      newitem.item_in_sale = true
    end
    if params[:add_coll] == 'on'
      newitem.collection_id = params[:collections_select]
    end
    if params[:add_aktion] == 'on'
      newitem.aktion_id = params[:aktion_select]
    end
    newitem.save

    if Dir.exists?('public/images/items/' + newitem.id.to_s)
      FileUtils.rm_rf('public/images/items/' + newitem.id.to_s)
    end
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

    if params[:act] == 'sub'
      redirect_to request.referer
      return
    end

    if params[:act] == 'ajax'
      redirect_to :controller => 'admin', :action => 'items'
    else
      redirect_to :controller => 'admin', :action => 'categories'
    end


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
    unless params[:addnewsubcategory][:subcat_order].blank?
      newcat.subcat_order = params[:addnewsubcategory][:subcat_order].to_i
    end
    newcat.subcat_filter = params[:addnewsubcategory][:subcat_filter].mb_chars.upcase
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
      newcat.update_column(:subcat_order , params[:addnewsubcategory][:subcat_order])
      newcat.update_column(:subcat_filter , params[:addnewsubcategory][:subcat_filter].mb_chars.upcase)
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
        @subcat_order = cat.subcat_order.to_s
        @subcat_filter = cat.subcat_filter
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
    @collection_active = 'active'
    @collections = Collection.all
  end
  def removefromcollection
    i= Item.find(params[:item_id])
    i.update_column(:collection_id, 0)
    redirect_to request.referer

  end
  def removefromaktion
    i= Item.find(params[:item_id])
    i.update_column(:aktion_id, 0)
    redirect_to request.referer

  end
  def addcollection
    if params[:action_type] == 'new'
      newcoll = Collection.new
      newcoll.collection_name = params[:addcollection][:collection_name]
      newcoll.collection_name_translit = Translit.convert(params[:addcollection][:collection_name].gsub(' ','-'), :english)
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
      if params[:collection_show_homepage] == 'on'
        newcoll.collection_show_homepage = true
      end
      newcoll.save
      redirect_to :controller => 'admin', :action => 'collections'
    end
    if params[:action_type] == 'edit'
      newcoll = Collection.find(params[:collection_id])
      newcoll.update_column(:collection_name , params[:addcollection][:collection_name])
      newcoll.update_column(:collection_name_translit , Translit.convert(params[:addcollection][:collection_name].gsub(' ','-'), :english))
      newcoll.update_column(:collection_page_title , params[:addcollection][:collection_page_title])
      newcoll.update_column(:collection_page_description , params[:addcollection][:collection_page_description])
      newcoll.update_column(:collection_description , params[:collection_description])

      if params[:collection_show_homepage] == 'on'
        newcoll.update_column(:collection_show_homepage,true)
      else
        newcoll.update_column(:collection_show_homepage,false)
      end
    if params[:addcollection][:collection_image].present?
      uploadedFile = params[:addcollection][:collection_image]
      if File.file?(Rails.root.join('public','images','collections', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end

      File.open(Rails.root.join('public','images','collections', uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      newcoll.update_column(:collection_image , uploadedFile.original_filename)
    end
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
      if coll.collection_show_homepage
      @collection_show_homepage = '1'

        end

      format.js
    end
  end
  def editaktion
    coll =Aktion.find(params[:aktion_id])
    respond_to do |format|
      @aktion_name = coll.aktion_name
      @aktion_image = coll.aktion_image
      @aktion_page_title = coll.aktion_page_title
      @aktion_page_description = coll.aktion_page_description
      @aktion_description = coll.aktion_description.html_safe
      @aktion_id = params[:aktion_id]
      if coll.aktion_show_homepage
        @aktion_show_homepage = '1'

      end

      format.js
    end
  end
  def addaktion
    if params[:action_type] == 'new'
      newcoll = Aktion.new
      newcoll.aktion_name = params[:addaktion][:aktion_name]
      newcoll.aktion_name_translit = Translit.convert(params[:addaktion][:aktion_name].gsub(' ','-'), :english)
      newcoll.aktion_page_title = params[:addaktion][:aktion_page_title]
      newcoll.aktion_page_description = params[:addaktion][:aktion_page_description]
      newcoll.aktion_description = params[:aktion_description]
      uploadedFile = params[:addaktion][:aktion_image]
      if File.file?(Rails.root.join('public','images','aktions', uploadedFile.original_filename))
        uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
      end

      File.open(Rails.root.join('public','images','aktions', uploadedFile.original_filename), 'wb' ) do |f|
        f.write(uploadedFile.read)
      end
      newcoll.aktion_image = uploadedFile.original_filename
      if params[:aktion_show_homepage] == 'on'
        newcoll.aktion_show_homepage = true
      end
      newcoll.save
      redirect_to :controller => 'admin', :action => 'aktions'
    end
    if params[:action_type] == 'edit'
      newcoll = Aktion.find(params[:aktion_id])
      newcoll.update_column(:aktion_name , params[:addaktion][:aktion_name])
      newcoll.update_column(:aktion_name_translit , Translit.convert(params[:addaktion][:aktion_name].gsub(' ','-'), :english))
      newcoll.update_column(:aktion_page_title , params[:addaktion][:aktion_page_title])
      newcoll.update_column(:aktion_page_description , params[:addaktion][:aktion_page_description])
      newcoll.update_column(:aktion_description , params[:aktion_description])

      if params[:aktion_show_homepage] == 'on'
        newcoll.update_column(:aktion_show_homepage,true)
      else
        newcoll.update_column(:aktion_show_homepage,false)
      end
      if params[:addaktion][:aktion_image].present?
        uploadedFile = params[:addaktion][:aktion_image]
        if File.file?(Rails.root.join('public','images','aktions', uploadedFile.original_filename))
          uploadedFile.original_filename = [*('a'..'z'),*('0'..'9')].shuffle[0,4].join + uploadedFile.original_filename
        end

        File.open(Rails.root.join('public','images','aktions', uploadedFile.original_filename), 'wb' ) do |f|
          f.write(uploadedFile.read)
        end
        newcoll.update_column(:aktion_image , uploadedFile.original_filename)
      end
      redirect_to :controller => 'admin', :action => 'aktions'
    end

  end
  def deleteaktion
       Aktion.destroy(params[:id])
       i = Item.where(aktion_id: params[:id])
       i.each do |item|
         item.update_column(:aktion_id,0)
       end
      redirect_to :controller => 'admin', :action => 'aktions'
  end
  def deletecollection
    Collection.destroy(params[:id])
    i = Item.where(collection_id: params[:id])
    i.each do |item|
      item.update_column(:collection_id,0)
    end
    redirect_to :controller => 'admin', :action => 'collections'
  end
  def add2collection

  end
end
