class Food < ApplicationRecord
    has_many :categorizations, dependent: :destroy
    has_many :categories, through: :categorizations
    has_many :reviews, dependent: :destroy
     has_one_attached :image
      extend FriendlyId
  friendly_id :name, use: :slugged
     # app/models/food.rb
scope :with_associations, -> { includes(:categories, :reviews) }
    
end
