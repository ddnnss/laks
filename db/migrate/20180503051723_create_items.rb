class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :subcategory
      t.string :item_name, index:true
      t.string :item_name_caps, index:true
      t.string :item_image1, :default => 'none'
      t.string :item_image2, :default => 'none'
      t.string :item_image3, :default => 'none'
      t.string :item_image4, :default => 'none'
      t.string :item_size, :default => 'не указано'
      t.string :item_model, :default => 'не указано'
      t.string :item_badge, :default => 'не указано'
      t.string :item_color, :default => 'не указано'
      t.text   :item_description, :default => ''
      t.text :item_page_title, :default => ''
      t.text :item_page_description, :default => ''

      t.integer :item_price
      t.integer :item_rating, :default => 0
      t.integer :item_discount, :default => 0
      t.integer :item_views_count, :default => 0

      t.boolean :item_in_sale, :default => false
      t.boolean :item_new, :default => false
      t.boolean :item_presents, :default => true
      t.timestamps
    end
  end
end