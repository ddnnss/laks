class Order < ApplicationRecord
  serialize :order_items, JSON
  serialize :order_guest_data, JSON
end
