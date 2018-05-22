class CartController < ApplicationController
  def addtocart
    item = Item.find(params[:item_id])


    respond_to do |format|
      @item_id = params[:item_id]
      @item_name = item.item_name
      @item_image = item.item_image1
      if item.item_discount > 0
        @item_price = item.item_price - (item.item_price * item.item_discount / 100)
      else
        @item_price = item.item_price
      end
      format.js
    end
    if session[:active]
    else
      if session[:cart].nil?
        session[:cart]=[]

        session[:cart].append(params[:item_id].to_i)

      else
        session[:cart].append(params[:item_id].to_i)
      end

    end


  end
end
