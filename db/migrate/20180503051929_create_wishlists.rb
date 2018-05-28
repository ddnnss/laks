class CreateWishlists < ActiveRecord::Migration[5.1]
  def change
    create_table :wishlists do |t|
      t.belongs_to :client
      t.string :wishlist_items, :default => ''
      t.timestamps


    end
  end
end
