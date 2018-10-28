class CreateAktions < ActiveRecord::Migration[5.1]
  def change
    create_table :aktions do |t|
      t.string   :aktion_name, :default => '', index: true
      t.string   :aktion_name_translit, :default => '', index: true
      t.string   :aktion_image, :default => ''
      t.integer  :aktion_views, :default => 0
      t.string   :aktion_page_title, :default => ''
      t.string   :aktion_page_description, :default => ''
      t.text     :aktion_description, :default => ''
      t.boolean  :aktion_show_homepage, :default => false, index: true
    end
  end
end
