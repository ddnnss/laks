class CreateSubcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :subcategories do |t|
      t.belongs_to :category
      t.string  :subcat_name, :default => '', index: true
      t.string  :subcat_name_translit, :default => '', index: true
      t.string  :subcat_image, :default => ''
      t.string  :subcat_comment, :default => ''
      t.integer :subcat_views, :default => 0

      t.string  :subcat_page_title, :default => ''
      t.string  :subcat_page_description, :default => ''
      t.text    :subcat_description, :default => ''

      t.string  :subcat_temp1

    end
  end
end
