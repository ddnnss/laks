class Cart < ApplicationRecord
  serialize :cart_items, JSON

end
