class MailerMailer < ApplicationMailer

  default from: 'LAKSHMI888.RU'

  def activation(mail)
    @user=mail
    mail(to: @user.client_email,subject: "Регистрация на сайте")
  end

end