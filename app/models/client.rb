class Client < ApplicationRecord
  has_one :cart, :dependent => :destroy
  has_one :wishlist

  validates :client_email,
            format: { with:/.+@.+\..+/i,message: 'Неправильный формат почты'},
            :uniqueness => {:message => 'Данный адрес уже зарегистрирован'}


  before_save :downcase_fields

  def downcase_fields
    self.client_email.downcase!
  end
end
