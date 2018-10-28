class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :check_cart?
  def current_user
    return unless session[:client_id]
    @current_user ||= Client.find(session[:client_id])
  end
  def check_cart?
    unless session[:cart].nil?
      summ = 0
      cart = Item.find(session[:cart].keys)
        cart.each do |i|
          summ = summ + i.item_opt_price * session[:cart][i.id.to_s]
          logger.info ('Стоимость корзины :' + summ.to_s)
      end
      if summ > 5000
        return true
      else
        return false
      end

    end
  end

  def client_admin
    return unless session[:client_id]
    @client_admin = current_user.client_admin
  end

end
