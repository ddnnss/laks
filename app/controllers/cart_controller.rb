class CartController < ApplicationController
  def addtocart
    item = Item.find(params[:item_id])

    if session[:active]
                          #корзина usera
    else
      if session[:cart].nil?  #корзина существует?
        logger.info('cart empty-----------------------------------')
        session[:cart]=Hash.new
        session[:cart][item.id] = 1
        @duplicate = false

      else
            if session[:cart].key? item.id.to_s #проверка дублирования товара в корзине
              logger.info('dup-----------------------------------')
              logger.info(session[:cart].inspect)
              logger.info(session[:cart][item.id.to_s])
                session[:cart][item.id.to_s] = session[:cart][item.id.to_s].to_i + 1
              logger.info(session[:cart][item.id.to_s])
                @duplicate = true
            else
              logger.info('new-----------------------------------')
              logger.info(session[:cart].inspect)
                session[:cart][item.id] = 1
                @duplicate = false
            end

      end

    end


      if @duplicate               #дупликата товара

        respond_to do |format| # дупликат товара
          @dup = @duplicate
          @item_id = item.id
          @item_count = session[:cart][item.id.to_s]
          if @item_count >= item.item_opt_price_count
            @item_price = item.item_opt_price
            @item_total_price = item.item_opt_price * @item_count
            @opt_price = true
            logger.info('send opt price-----------------------------------')
            logger.info(@item_total_price)
           else
             if item.item_discount > 0
               @item_price = item.item_price - (item.item_price * item.item_discount / 100)
               @item_total_price = @item_price * @item_count
               @opt_price = false
             else
               @item_price = item.item_price
               @item_total_price = @item_price * @item_count
               @opt_price = false
             end
          end

          logger.info('send dup-----------------------------------')
          logger.info(@dup)
        format.js
        end

      else
        respond_to do |format| #нет дупликата товара
          @dup = @duplicate
          @item_id = item.id
          @item_name = item.item_name
          @item_image = item.item_image1
          if item.item_discount > 0
            @item_price = item.item_price - (item.item_price * item.item_discount / 100)
          else
            @item_price = item.item_price
          end
          format.js
        end

      end




  end
end
