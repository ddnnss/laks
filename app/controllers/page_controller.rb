class PageController < ApplicationController
  before_action :getmenu
  def index
    @cat_all = Category.all
    @w=['','one','two','three','four','five','six']

  end

  def showcategory
@cat = Category.find_by_cat_name_translit(params[:name])
  end

  def getmenu
    @menu_drop = Category.all
    @menu_cat = Category.where(show_in_menu: true)
  end
end
