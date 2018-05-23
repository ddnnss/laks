class PageController < ApplicationController
  before_action :getmenu, :getcart
  def index
    @title = 'Купить сувениры оптом дешево в Москве. Интернет-магазин оригинальных и необычных подарков оптом Лакшми'
    @description = 'Оригинальные и необычные сувениры и подарки в интернет-магазине lakshmi888.ru мелким и крупным оптом в Москве.'
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')

  end

  def showcategory

    @cat = Category.find_by_cat_name_translit(params[:name])
    @cat.update_column(:cat_views, @cat.cat_views + 1)
    @title = @cat.cat_page_title
    @description = @cat.cat_page_description
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
  end
  def showsubcategory

    @subcat = Subcategory.find_by_subcat_name_translit(params[:name])
    @subcat.update_column(:subcat_views, @subcat.subcat_views + 1)
    @parent_cat = Category.find(@subcat.category_id)
    @title = @subcat.subcat_page_title
    @description = @subcat.subcat_page_description
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
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

end
