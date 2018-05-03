class CreateSubcategories < ActiveRecord::Migration[5.1]
  def change
    create_table :subcategories do |t|
      t.belongs_to :category
      t.string :subcat_name
      t.string :subcat_image
      t.string :subcat_title
      t.string :subcat_description

    end
  end
end
