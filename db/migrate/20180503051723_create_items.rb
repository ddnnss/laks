class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :subcategory
      t.belongs_to :collection
      t.string :item_name
      t.string :item_name_caps, index:true
      t.string :item_name_translit, :default => '', index: true
      t.string :item_image1, :default => 'none'
      t.string :item_image2, :default => 'none'
      t.string :item_image3, :default => 'none'
      t.string :item_image4, :default => 'none'
      t.string :item_size, :default => 'не указано'
      t.string :item_article, :default => 'не указано'
      t.string :item_weight, :default => 'не указано'
      t.string :item_tags, :default => ''
      t.text   :item_description, :default => ''
      t.text :item_page_title, :default => ''
      t.text :item_page_description, :default => ''

      t.integer :item_price
      t.integer :item_opt_price
      t.integer :item_opt_price_count
      t.integer :item_rating, :default => 0
      t.integer :item_discount, :default => 0
      t.integer :item_views_count, :default => 0

      t.boolean :item_in_sale, :default => false, index: true
      t.boolean :item_in_collection, :default => false, index: true
      t.boolean :item_new, :default => false, index: true
      t.boolean :item_presents, :default => true
      t.timestamps
    end
  end
end