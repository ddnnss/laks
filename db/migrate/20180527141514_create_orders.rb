class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :client
      t.text :order_items
      t.string :order_status,index: true
      t.string :order_summ
      t.string :order_discount_code
      t.text :order_guest_data
      t.string :order_dostavka
      t.string :order_oplata
      t.string :order_tracking,index: true
      t.string :order_number,index: true

      t.string :order_temp1
      t.string :order_temp2
      t.string :order_temp3
      t.string :order_temp4
      t.timestamps
    end
  end
end
