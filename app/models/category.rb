class Category < ApplicationRecord
  # Define this first
  has_many :categorizations, dependent: :destroy
  has_many :foods, through: :categorizations

  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  
   extend FriendlyId
  friendly_id :name, use: :slugged

  # Hierarchical structure
 has_many :children, class_name: "Category", foreign_key: "parent_id"
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
end
