class CreateSendmails < ActiveRecord::Migration[5.1]
  def change
    create_table :sendmails do |t|
      t.text :mail_text
      t.string :mail_subject

      t.timestamps
    end
  end
end
