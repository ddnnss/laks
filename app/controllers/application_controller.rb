class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :check_cart?

  def check_cart?
    unless session[:cart].nil?
      summ = 0
      cart = Item.find(session[:cart].keys)
        cart.each do |i|
          summ = summ + i.item_price * session[:cart][i.id.to_s]
          logger.info ('Стоимость корзины :' + summ.to_s)
      end
      if summ > 5000
        return true
      else
        return false
      end

    end
  end
end
