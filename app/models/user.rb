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

  # Allow only safe attributes to be searchable with Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at] # keep it minimal & safe
  end

  def self.ransackable_associations(auth_object = nil)
    [] # none unless you explicitly want to allow associations
  end
 # app/models/user.rb
def admin?
  admin
end


end
