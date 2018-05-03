class Client < ApplicationRecord
  has_one :cart, :dependent => :destroy
  has_one :wishlist
end
