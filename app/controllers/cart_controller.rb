class CartController < ApplicationController
  def addtocart
    item = Item.find(params[:item_id])

    if session[:active]
      logger.info('[INFO] : Авторизованный режим корзины. ')

    else
      logger.info('[INFO] : Гостевой режим корзины. ')
      if session[:cart].nil?  #корзина существует?
        logger.info('[INFO] : Инициализация корзины. Обработка ......')
        session[:cart]=Hash.new
        session[:cart][item.id] = 1
        @duplicate = false

      else
            if session[:cart].key? item.id.to_s #проверка дублирования товара в корзине
              logger.info('[INFO] : Существующий товар. Обработка ......')

                session[:cart][item.id.to_s] = session[:cart][item.id.to_s].to_i + 1

                @duplicate = true
            else
              logger.info('[INFO] : Новый товар. Обработка ......')

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
          if @item_count >= item.item_opt_price_count #оптовая цена
            @item_price = item.item_opt_price
            @item_total_price = item.item_opt_price * @item_count
            @opt_price = true
            logger.info('[INFO] : Существующий товар обновлен по оптовой цене.')
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

          logger.info('[INFO] : Существующий товар обновлен.')
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
          logger.info('[INFO] : Новый товар добавлен в корзину.')
          format.js
        end

      end




  end

  def removeitem
    if params[:id].present?
      session[:cart].delete(params[:id])
      redirect_to checkout_path
      logger.info('[INFO] : Товар удален из корзины.')
    else
      logger.info('[ERROR] : Нет ID товара для удаления.')
      redirect_to checkout_path
    end

  end
end
