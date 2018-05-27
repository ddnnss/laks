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
    logger.info('[INFO] : Меню получено.')

  end

  def checkout
    @title = 'Купить сувениры оптом дешево в Москве. Интернет-магазин оригинальных и необычных подарков оптом Лакшми'
    @description = 'Оригинальные и необычные сувениры и подарки в интернет-магазине lakshmi888.ru мелким и крупным оптом в Москве.'
    @keywords=@description.gsub(' и ',' ').gsub(' в ',' ').split(' ').join(',')

    if session[:cart].empty?
      redirect_to '/'
      logger.info('[ERROR] : Корзина пуста. Переход на главную страницу.')
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

  def placeorder
    if session[:active]

    else
      if params[:guest_register] == 'on' #guest register
        @client =Client.new(client_data)
            if @client.valid?                  #guest email check
            else                               #guest email bad
              flash[:email_error] = @client.errors[:client_email][0].to_s
              logger.info('[ERROR] : Юзер ввел не верный EMAIL')
              redirect_to checkout_path
            end
      end
      guest_data = Hash.new
      neworder = Order.new
      neworder.client_id = 0
      neworder.order_status = 'Заказ принят'
      neworder.order_items = session[:cart]
      neworder.order_summ = session[:cart_total]

      params[:placeorder].each do |key,val|
        guest_data[key]=val
      end
      neworder.order_guest_data = guest_data
      neworder.order_dostavka = params[:guest_dostavka]
      neworder.order_oplata = params[:guest_oplata]
      neworder.save
      session[:order]= Base64.encode64([*('a'..'z'),*('0'..'9')].shuffle[0,8].join)
      logger.info('[INFO] : Заказ сохранен в БД. Гость не зарегистрирован.')
      logger.info('[INFO] : Отправка письма пользователю.....' + params[:placeorder][:client_email])

      MailerMailer.neworder(params[:placeorder][:client_email],session[:cart],session[:order]).deliver_later
      a=session[:cart].keys
       a.each do |k|
        session[:cart].delete(k)
      end

      logger.info('[INFO] : Корзина очищена, переход на страницу подтверждения заказа')
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


  def getcart

    if session[:active]
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
