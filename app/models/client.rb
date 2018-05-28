class Client < ApplicationRecord
  serialize :client_cart_items, JSON
  has_many :orders


  validates :client_email,
            format: { with:/.+@.+\..+/i,message: 'Неправильный формат почты'},
            :uniqueness => {:message => 'Данный адрес уже зарегистрирован'}


  before_save :downcase_fields

  def downcase_fields
    self.client_email.downcase!
  end
end
