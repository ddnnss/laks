class PageController < ApplicationController
  def index

  end

  def showcategory
@cat = Category.find_by_cat_name_translit(params[:name])
  end
end
