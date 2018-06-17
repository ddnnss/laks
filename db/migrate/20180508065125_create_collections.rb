class CreateCollections < ActiveRecord::Migration[5.1]
  def change
    create_table :collections do |t|
      t.string   :collection_name, :default => '', index: true
      t.string   :collection_name_translit, :default => '', index: true
      t.string   :collection_image, :default => ''
      t.string   :collection_comment, :default => ''
      t.integer  :collection_views, :default => 0
      t.string     :collection_page_title, :default => ''
      t.string     :collection_page_description, :default => ''
      t.text     :collection_description, :default => ''
      t.boolean     :collection_show_homepage, :default => false, index: true
      t.string   :collection_temp1

    end
  end
end
