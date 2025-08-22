class Category < ApplicationRecord
  # Define this first
  has_many :categorizations, dependent: :destroy
  has_many :foods, through: :categorizations

  # Hierarchical structure
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
end
