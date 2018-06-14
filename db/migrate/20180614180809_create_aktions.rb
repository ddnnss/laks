class CreateAktions < ActiveRecord::Migration[5.1]
  def change
    create_table :aktions do |t|
      t.string :aktion_name
      t.string :aktion_name_translit
      t.string :aktion_expire
      t.string :aktion_image
    end
  end
end
