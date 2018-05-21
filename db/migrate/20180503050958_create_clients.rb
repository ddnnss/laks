class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string  :client_email, index: true
      t.string  :client_name, :default => ''
      t.string  :client_family, :default => ''
      t.string  :client_phone, :default => ''
      t.string  :client_country, :default => ''
      t.string  :client_city, :default => ''
      t.string  :client_address, :default => ''
      t.string  :client_password
      t.string  :client_view_history, :default => ''
      t.date    :client_last_login

      t.boolean :client_vip, :default => false
      t.boolean :client_mail_subscribe,:default => true
      t.boolean :client_activated, :default => false
      t.boolean :client_admin, :default => false

      t.timestamps
    end
  end
end
