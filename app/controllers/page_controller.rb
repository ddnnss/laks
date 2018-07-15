class PageController < ApplicationController
  before_action :getmenu, :getcart
  def index
    @title = 'Купить сувениры оптом дешево в Москве.'
    @description = 'Оригинальные и необычные сувениры и подарки в интернет-магазине lakshmi888.ru мелким и крупным оптом в Москве.'
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
    @slides = Slider.all
    @collections = Collection.where(collection_show_homepage: true)
    if Item.where(item_in_sale: true).count < 3
      @action_items=[]
    else
      @action_items = Item.where(item_in_sale: true).random_records(3)
    end
    session[:newclient]=false

  end
  def login_mobile
    if session[:active]
      redirect_to root_path
    end

  end
  def search
    @q = params[:q].mb_chars.upcase
    @items = Item.paginate(:page => params[:page],:per_page => 12).where('item_name_caps LIKE ?','%'+params[:q].mb_chars.upcase+'%')
    if @items.blank?
      @items = Item.paginate(:page => params[:page],:per_page => 12).where('item_article LIKE ?','%'+params[:q]+'%')
    end

  end
  def showcollection
    logger.info('[INFO] : Получение товаров из коллекции....')
    @coll = Collection.find_by_collection_name_translit(params[:name])
    if params[:sort_type].present?
      case params[:sort_type]
      when '1'
        @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_name desc')
      when '2'
        @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_name asc')
      when '3'
        @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_price desc')
      when '4'
        @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_price asc')
      when '5'
        @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_discount desc')
      when '6'
        @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_discount asc')

      end
    else
      @items = @coll.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_name desc')
    end

    if params[:search]!='' && params[:search].present?

      @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).where('item_name_caps LIKE ?','%'+params[:search].mb_chars.upcase+'%')

    else

    end






    @coll.update_column(:collection_views, @coll.collection_views + 1)

    logger.info('[INFO] : Товары получены.')
    @title = @coll.collection_page_title
    @description = @coll.collection_page_description
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
    if session[:active]
      client = Client.find(session[:client_id])
      @wishlist = client.client_wishlist.split(',')
    end



  end

  def showcategory
    logger.info('[INFO] : Получение категорий товаров....')
    @cat = Category.find_by_cat_name_translit(params[:name])
    @cat.update_column(:cat_views, @cat.cat_views + 1)
    logger.info('[INFO] : Категории получены.')
    @title = @cat.cat_page_title
    @description = @cat.cat_page_description
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
  end
  def showsubcategory
    logger.info('[INFO] : Получение подкатегорий товаров....')
    @subcat = Subcategory.find_by_subcat_name_translit(params[:name])
    if params[:sort_type].present?
      case params[:sort_type]
        when '1'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_name desc')
        when '2'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_name asc')
        when '3'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_price desc')
        when '4'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_price asc')
        when '5'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_discount desc')
        when '6'
          @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_discount asc')

      end
    else
      @items = @subcat.items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).order('item_name desc')
    end

    if params[:search]!='' && params[:search].present?

      @items = @items.paginate(:page => params[:page], :per_page => params[:pp].present? ? params[:pp] : 12 ).where('item_name_caps LIKE ?','%'+params[:search].mb_chars.upcase+'%')

    else

    end






    @subcat.update_column(:subcat_views, @subcat.subcat_views + 1)
    @parent_cat = Category.find(@subcat.category_id)
    logger.info('[INFO] : Подкатегорий получены.')
    @title = @subcat.subcat_page_title
    @description = @subcat.subcat_page_description
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
    if session[:active]
      client = Client.find(session[:client_id])
      @wishlist = client.client_wishlist.split(',')
    end


  end

  def showitem
    @item = Item.find_by_item_name_translit(params[:item_name])
    if @item.nil?
      redirect_to request.referer
      return
    else
      @item.update_column(:item_views_count,@item.item_views_count + 1)
          if session[:active]
            client = Client.find(session[:client_id])
                if client.client_view_history != ''
                  req = client.client_view_history.split (',')
                  @vieweditems = Item.where(id: req - [@item.id.to_s] )
                  unless req.include?(@item.id.to_s)
                  req.append(@item.id)
                  client.update_column( :client_view_history , req.join(','))
                  end

                else
                  client.update_column( :client_view_history , @item.id)
                  @vieweditems = []
                end
            @wishlist = client.client_wishlist
          else

            logger.info('История просмотров гостя: ' +  session[:view_history].inspect)
            if session[:view_history].nil? || session[:view_history] ==''
              session[:view_history] = []
              session[:view_history] << @item.id
              @vieweditems = []
            else
              @vieweditems = Item.where(id: session[:view_history] - [@item.id] )
              unless session[:view_history].include?(@item.id)
                session[:view_history].append @item.id
              end
            end

          end

      @title = @item.item_page_title
      @description = @item.item_page_description
      @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
      @subcat = Subcategory.find(@item.subcategory_id)
      @maincat = Category.find(@subcat.category_id)
    end
  end

  def getmenu
    @cat_all = Category.all
    @menu_cat = Category.where(show_in_menu: true)
    logger.info('[INFO] : Меню получено.')

  end

  def checkout
    @title = 'Купить сувениры оптом дешево в Москве. Интернет-магазин оригинальных и необычных подарков оптом Лакшми'
    @description = 'Оригинальные и необычные сувениры и подарки в интернет-магазине lakshmi888.ru мелким и крупным оптом в Москве.'
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')


    if session[:cart].empty?

      logger.info('[ERROR] : Корзина пуста. Переход на главную страницу.')
      redirect_to '/'

    else
      if session[:active]
        client = Client.find(session[:client_id])
        session[:cart_total] = 0

        if params[:editcart].present?
          params.except(:utf8,:authenticity_token,:editcart,:controller,:action).each do |key,val|
            session[:cart][key.to_i]=val.to_i

          end
          client.update_column(:client_cart_items , session[:cart])
          logger.info('[INFO] : Корзина обновлена. Переход на страницу заказа.')
          redirect_to checkout_path
        else


        end
        else
          session[:cart_total] = 0

          if params[:editcart].present?
            params.except(:utf8,:authenticity_token,:editcart,:controller,:action).each do |key,val|
              session[:cart][key.to_i]=val.to_i
            end
            logger.info('[INFO] : Корзина обновлена. Переход на страницу заказа.')
            redirect_to checkout_path
          else


          end
      end

    end


  end

  def placeorder
    if session[:active]
      logger.info('[INFO] : Инициализация сохранения заказа в основном режиме.....')

      neworder = Order.new
      session[:order]= ([*('a'..'z'),*('0'..'9')].shuffle[0,2].join + '-' +[*('a'..'z'),*('0'..'9')].shuffle[0,4].join + '-' +[*('a'..'z'),*('0'..'9')].shuffle[0,2].join).upcase
      if session[:discount_value] == '0'
        discount_summ = 0
      else
        discount_summ = 0
        discount_summ = session[:cart_total].to_i * session[:discount_value].to_i / 100
      end
      neworder.client_id = session[:client_id]
      neworder.order_status = 'Заказ принят'
      neworder.order_items = session[:cart]
      neworder.order_summ = session[:cart_total].to_i - discount_summ


      neworder.order_dostavka = params[:member_dostavka]
      neworder.order_oplata = params[:member_oplata]
      neworder.order_number = session[:order]
      neworder.save

      logger.info('[INFO] : Заказ сохранен в БД в основном режиме.')
      logger.info('[INFO] : Отправка письма пользователю.....' +  session[:client_email])

      MailerMailer.neworder(session[:client_email],session[:cart],session[:order],session[:discount_value]).deliver_later
      a=session[:cart].keys
      a.each do |k|
        session[:cart].delete(k)
      end
      logger.info('[INFO] : Корзина очищена в сессии.')
      session[:discount_value] = '0'
      c = Client.find(session[:client_id])
      c.update_column(:client_cart_items,nil)
      logger.info('[INFO] : Корзина очищена в БД, переход на страницу успешного размещения заказа')
      redirect_to order_path


    else
      if params[:guest_register] == 'on' #guest register
        logger.info('[INFO] : Инициализация сохранения заказа с регистрацией.....')
        @client =Client.new(client_data)
            if @client.valid?                  #guest email check
              @client.client_password = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
              @client.client_name = params[:placeorder][:guest_name]
              @client.client_family = params[:placeorder][:guest_family]
              @client.client_phone = params[:placeorder][:guest_phone]
              @client.client_country= params[:placeorder][:guest_country]
              @client.client_city= params[:placeorder][:guest_city]
              @client.client_post_code= params[:placeorder][:guest_post_code]
              @client.client_address= params[:placeorder][:guest_address]
              @client.save
              session[:newclient]=true
              logger.info('[INFO] : Новый позьзователь успешно зарегистрирован.')
              MailerMailer.activation(@client).deliver_later
            else                               #guest email bad
              flash[:email_error] = @client.errors[:client_email][0].to_s
              logger.info('[ERROR] : Юзер ввел не верный EMAIL')
              redirect_to checkout_path
              return
            end
      end
      logger.info('[INFO] : Инициализация сохранения заказа в гостевом режиме.....')
      guest_data = Hash.new
      neworder = Order.new
      session[:order]= ([*('a'..'z'),*('0'..'9')].shuffle[0,2].join + '-' +[*('a'..'z'),*('0'..'9')].shuffle[0,4].join + '-' +[*('a'..'z'),*('0'..'9')].shuffle[0,2].join).upcase
      if session[:discount_value] == '0'
        discount_summ = 0
      else
        discount_summ = 0
      discount_summ = session[:cart_total].to_i * session[:discount_value].to_i / 100
      end
      neworder.client_id = 0
      neworder.order_status = 'Заказ принят'
      neworder.order_items = session[:cart]
      neworder.order_summ = session[:cart_total].to_i - discount_summ

      params[:placeorder].each do |key,val|
        guest_data[key]=val
      end
      if params[:guest_register] == 'on'
        neworder.client_id = @client.id
      else
        neworder.order_guest_data = guest_data
      end

      neworder.order_dostavka = params[:guest_dostavka]
      neworder.order_oplata = params[:guest_oplata]
      neworder.order_number = session[:order]
      neworder.save

      logger.info('[INFO] : Заказ сохранен в БД в гостевом режиме.')
      logger.info('[INFO] : Отправка письма пользователю.....' + params[:placeorder][:client_email])

      MailerMailer.neworder(params[:placeorder][:client_email],session[:cart],session[:order],session[:discount_value]).deliver_later
      a=session[:cart].keys
       a.each do |k|
        session[:cart].delete(k)
       end
      session[:discount_value] = '0'

      logger.info('[INFO] : Корзина очищена, переход на страницу успешного размещения заказа')
      redirect_to order_path






    end

  end

  def order_info
    @title = 'Купить сувениры оптом дешево в Москве. Интернет-магазин оригинальных и необычных подарков оптом Лакшми'
    @description = 'Оригинальные и необычные сувениры и подарки в интернет-магазине lakshmi888.ru мелким и крупным оптом в Москве.'
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')
    session[:cart_total] = 0
    session[:total] = 0
  end

  def orderstatus

  end

  def profile
    @client_info = Client.find(session[:client_id])
    @client_orders = Order.where(client_id: @client_info.id )
    @client_wishlist = Item.where(id: @client_info.client_wishlist.split(','))
    if params[:client_action]=='update'
      @client_info.update_column(:client_name,params[:client_name])
      @client_info.update_column(:client_family,params[:client_family])
      @client_info.update_column(:client_phone,params[:client_phone])
      @client_info.update_column(:client_email,params[:client_email])
      @client_info.update_column(:client_country,params[:client_country])
      @client_info.update_column(:client_city,params[:client_city])
      @client_info.update_column(:client_post_code,params[:client_post_code])
      @client_info.update_column(:client_address,params[:client_address])
      session[:client_data_bad] = false
      redirect_to request.referer


    end

  end


  def getcart

    if session[:active]
      if session[:cart].nil?
        session[:total] = 0
        logger.info('[INFO] : Корзина пуста.')
      else
        session[:total] = 0
        @cart= Item.find(session[:cart].keys)
        logger.info('[INFO] : Корзина получена.')
      end
    else
      if session[:cart].nil?
        session[:total] = 0
        logger.info('[INFO] : Корзина пуста.')
      else
        session[:total] = 0
        @cart= Item.find(session[:cart].keys)
        logger.info('[INFO] : Корзина получена.')
      end

    end
  end

  private
  def client_data
    params.require(:placeorder).permit(:client_email)
  end

end
