class MailerMailer < ApplicationMailer

  default from: 'LAKSHMI888.RU'

  def activation(mail)
    @user=mail
    mail(to: @user.client_email,subject: "Регистрация на сайте LAKSHMI888.RU")
  end

  def neworder(mail,items,code)
    @mail=mail
    @cart_items = items
    @cart_total = 0
    @item_total = 0
    @code=code
    @cart_itemss = Item.find(@cart_items.keys)
    mail(to: @mail,subject: "Ваш заказ успешно размещен")
    logger.info('[INFO] : Письмо на ' + @mail + ' отправлено')
  end
end