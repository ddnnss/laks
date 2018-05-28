class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string    :discount_code,index: true
      t.string    :discount_discount_value
      t.boolean   :discount_for_one_use
      t.date      :discount_expiry
      t.timestamps
    end
  end
end
