class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections do |t|
      t.string :collection_name, :default => '', index: true
      t.string :collection_name_translit, :default => '', index: true
      t.string :collection_image, :default => ''
      t.text   :collection_page_title, :default => ''
      t.text   :collection_page_description, :default => ''
      t.text   :collection_description, :default => ''

    end
  end
end
