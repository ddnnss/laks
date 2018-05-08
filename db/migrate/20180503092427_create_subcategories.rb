class CreateSubcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :subcategories do |t|
      t.belongs_to :category
      t.string :subcat_name, :default => '', index: true
      t.string :subcat_name_translit, :default => '', index: true
      t.string :subcat_image, :default => ''
      t.text :subcat_page_title, :default => ''
      t.text :subcat_page_description, :default => ''
      t.text   :subcat_description, :default => ''

    end
  end
end
