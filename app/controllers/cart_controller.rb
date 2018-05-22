class CartController < ApplicationController
  def addtocart
    item = Item.find(params[:item_id])

    respond_to do |format|
      @item_id = params[:item_id]
      @item_name = item.item_name
      @item_image = item.item_image1
      @item_price = item.item_price

      format.js
    end

  end
end
