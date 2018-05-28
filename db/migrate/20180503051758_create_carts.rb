class CreateCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :carts do |t|
      t.belongs_to :client
      t.text :cart_items
      t.string :cart_status, :default => '', index: true
      t.timestamps


    end
  end
end
