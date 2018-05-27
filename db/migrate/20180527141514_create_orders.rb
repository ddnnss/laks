class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :client
      t.text :order_items
      t.string :order_status
      t.string :order_summ
      t.string :order_discount_code
      t.text :order_guest_data
      t.string :order_dostavka
      t.string :order_oplata
      t.string :order_tracking
      t.string :order_number


      t.timestamps
    end
  end
end
