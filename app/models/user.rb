class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2, :tiktok, :facebook]

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

def self.from_omniauth(auth)
  return nil unless auth

  user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
  user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
  user.password ||= Devise.friendly_token[0, 20]
  user.name = auth.info.name if user.respond_to?(:name)
  user.confirmed_at ||= Time.current
  user.save!
  user
end


end
