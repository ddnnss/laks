class MailerMailer < ApplicationMailer



  def activation(mail)
    @user=mail
    mail(to: @user.client_email,subject: "Регистрация на сайте LAKSHMI888.RU")
  end
  def newpass(mail)
    @user=mail
    mail(to: @user.client_email,subject: "Восстановление пароля на сайте LAKSHMI888.RU")
  end

  def neworder(mail,items,code,discount)
    @mail=mail
    @cart_items = items
    @cart_total = 0
    @item_total = 0
    @code=code
    @discount=discount
    @order = Order.find_by_order_number(code)
    if @order.client_id == 0
      @order_guest = true
    else
      @order_guest = false
      @customer = Client.find(@order.client_id)
    end
    @cart_itemss = Item.find(@cart_items.keys)
    mail(to: @mail,subject: "Ваш заказ успешно размещен")
    logger.info('[INFO] : Письмо на ' + @mail + ' отправлено')
  end

  def sendmails(email,text,subject)
    @mail_text = text
    mail(to: email,subject: subject)
  end

end