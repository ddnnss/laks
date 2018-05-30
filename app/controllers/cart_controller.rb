class CartController < ApplicationController
  def addtocart
    item = Item.find(params[:item_id])


    if session[:active]
      logger.info('[INFO] : Авторизованный режим корзины. ')
      client = Client.find(session[:client_id])

      if session[:cart].nil?  #корзина существует?
        logger.info('[INFO] : Инициализация корзины. Обработка ......')
        session[:cart]=Hash.new
        session[:cart][item.id] = 1
        @duplicate = false
        client.update_column(:client_cart_items , session[:cart])

      else
        if session[:cart].key? item.id.to_s #проверка дублирования товара в корзине
          logger.info('[INFO] : Существующий товар. Обработка ......')

          session[:cart][item.id.to_s] = session[:cart][item.id.to_s].to_i + 1
          client.update_column(:client_cart_items , session[:cart])
          @duplicate = true
        else
          logger.info('[INFO] : Новый товар. Обработка ......')

          session[:cart][item.id] = 1
          client.update_column(:client_cart_items , session[:cart])
          @duplicate = false
        end

      end

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
          @item_name = item.item_name
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
      if session[:active]
        client = Client.find(session[:client_id])
        session[:cart].delete(params[:id])
        client.update_column(:client_cart_items , session[:cart])
        redirect_to checkout_path
        logger.info('[INFO] : Товар удален из корзины.')
      else
        session[:cart].delete(params[:id])
        redirect_to checkout_path
        logger.info('[INFO] : Товар удален из корзины.')
      end

    else
      logger.info('[ERROR] : Нет ID товара для удаления.')
      redirect_to checkout_path
    end

  end

  def add_to_wishlist
    if session[:active]
      logger.info('[INFO] :Сессия доступна, добавление в закладки товара.....')
      client = Client.find(session[:client_id])
      if client.client_wishlist != ''
        req = client.client_wishlist.split (',')
        req.append(params[:item_id])
        client.update_column( :client_wishlist , req.join(','))
      else
        client.update_column( :client_wishlist , params[:item_id])
      end
      respond_to do |format|
        logger.info('[INFO] : Товар добавлен в закладки.')
        @status='ok'
        @item_id = params[:item_id]
        format.js
      end
    else
      logger.info('[ERROR] :Нет сессии, добавление в закладки невозможно.')
      respond_to do |format|

        @status='err'
        @item_id = params[:item_id]
        format.js
      end
    end

  end

  def applydiscount
    logger.info('[INFO] :Запрос на применение купона на скидку.....')

              discount = Discount.find_by_discount_code(params[:discount_code])
    session[:discount_value]='0'
              if discount.nil?
                  logger.info('[ERROR] :Скидочный купон не найден.')
                  @discout_result = false
                else
                  logger.info('[INFO] :Скидочный купон найден.')
                  if discount.discount_for_one_use
                    logger.info('[INFO] :Купон одноразовый.')
                    @discout_result = true
                    discount_value = discount.discount_discount_value
                    session[:discount_value] = discount_value
                    discount.destroy!
                    logger.info('[INFO] :Скидочный купон удален из базы.')
                  else
                    logger.info('[INFO] :Купон многоразовый. Проверка срока действия.')
                    if Date.today >= discount.discount_expiry
                      logger.info('[ERROR] :Срока действия купона закончен.')
                      @discout_result = false
                    else
                      logger.info('[INFO] :Срока действия купона актуален.')
                      discount_value = discount.discount_discount_value
                      session[:discount_value] = discount_value
                      @discout_result = true
                    end

                  end


              end

              if @discout_result
                logger.info('[INFO] :Применение купона.')
                respond_to do |format|
                  @res = @discout_result
                  @dis_value = discount_value
                  format.js
                end
              else
                respond_to do |format|
                  @res = @discout_result
                  format.js
               end
          end




  end

end
