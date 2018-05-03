class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :subcategory
      t.string :item_name, index:true
      t.string :item_name_caps, index:true
      t.string :item_image, :default => ''
      t.string :item_size, :default => ''
      t.string :item_model, :default => ''
      t.string :item_badge, :default => ''
      t.string :item_page_title, :default => ''
      t.string :item_page_description, :default => ''

      t.integer :item_price
      t.integer :item_rating, :default => 0
      t.integer :item_discount, :default => 0
      t.integer :item_views_count, :default => 0

      t.boolean :item_in_sale, :default => false
      t.boolean :item_presents, :default => true

    end
  end
end