class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string  :client_email, index: true            #мыло клиента
      t.string  :client_name, :default => ''          #имя клиента
      t.string  :client_family, :default => ''        #фамилия клиента
      t.string  :client_ot4estvo, :default => ''      #отчество клиента (вводит админ)
      t.string  :client_passport, :default => ''      #паспортные данные клиента (вводит админ)
      t.string  :client_phone, :default => ''         #телефон клиента
      t.string  :client_country, :default => ''       #страна клиента
      t.string  :client_city, :default => ''          #город клиента
      t.string  :client_post_code, :default => ''     #индекс клиента
      t.string  :client_address, :default => ''       #адрес клиента
      t.string  :client_password                      #пароль клиента
      t.string  :client_view_history, :default => ''  #история просмотров товаров клиента
      t.string  :client_wishlist, :default => ''      #закладки клиента

      t.date    :client_last_login                    #дата последнкго входа клиента
      t.text    :client_cart_items                    #корзина клиента
      t.text    :client_comment, :default => ''       #комментарий для клиента (вводит админ)

      t.boolean :client_vip, :default => false           # клиент вип ? (0\1)
      t.boolean :client_mail_subscribe,:default => true  # клиент подписан на рассылку рекламных сообщений ? (0\1)
      t.boolean :client_activated, :default => false     # клиент подтвердил адрес почты после регистрации ? (0\1)
      t.boolean :client_admin, :default => false         # админ аккаунт ? (0\1)

      t.timestamps
    end
  end
end
