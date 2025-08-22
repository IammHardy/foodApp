class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  # Add any user relationships or validations here
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items
  has_many :reviews, dependent: :destroy


  after_create :create_cart

 # app/models/user.rb
def admin?
  admin
end


end
