class AdminController < ApplicationController
  def items
    @maincat = Category.where(cat_main: true)

  end
  def categories
    @maincat = Category.all

  end

  def addnewcategory
    newcat = Category.new
    newcat.cat_name = params[:addnewcategory][:maincat_name]
    newcat.save
    Dir.mkdir('public/images/maincategory/' + newcat.id.to_s)
    redirect_to :controller => 'admin', :action => 'categories'

  end
  def addnewsubcategory
    newcat = Subcategory.new
    newcat.category_id = params[:cat_id]
    newcat.subcat_name = params[:addnewsubcategory][:subcat_name]
    newcat.save
    Dir.mkdir('public/images/maincategory/'+ params[:cat_id.to_s] + '/' + newcat.id.to_s)
    redirect_to :controller => 'admin', :action => 'categories'
  end
  def deletecategory
    if params[:type] == 'main'
    Category.destroy(params[:id])
    FileUtils.rm_rf('public/images/maincategory/' + params[:id])
    else
      Subcategory.destroy(params[:id])
      FileUtils.rm_rf('public/images/maincategory/' + params[:maincat] + '/' + params[:id])
    end
    redirect_to :controller => 'admin', :action => 'categories'
  end
end
