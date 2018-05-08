class CreateSliders < ActiveRecord::Migration[5.1]
  def change
    create_table :sliders do |t|
      t.string :slider_image
      t.string :slider_text1
      t.string :slider_text2
      t.string :slider_text3
      t.string :slider_url


    end
  end
end
