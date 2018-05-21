class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string   :cat_name, :default => '', index: true
      t.string   :cat_name_translit, :default => '', index: true
      t.string   :cat_image, :default => ''
      t.text     :cat_page_title, :default => ''
      t.text     :cat_page_description, :default => ''
      t.text     :cat_description, :default => ''
      t.integer  :cat_views, :default => 0

      t.boolean  :show_in_menu, :default => false, index: true




    end
  end
end
