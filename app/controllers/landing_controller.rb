class LandingController < ApplicationController
  include Rails.application.routes.url_helpers
  
  def index
    
    @foods = Food.with_attached_image
    @main_categories = Category.where(parent_id: nil).includes(:children)

    # Remove the old Food-specific variables
    # @food_category and @food_subcategories are no longer needed
    # Use @main_categories and each category's children in the view instead

    @featured_foods = Food.limit(3)
    @testimonials = Testimonial.limit(3)
  end
end
