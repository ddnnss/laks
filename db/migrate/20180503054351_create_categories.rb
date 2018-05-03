class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :cat_name
      t.string :cat_image
      t.string :cat_title
      t.string :cat_description




    end
  end
end
