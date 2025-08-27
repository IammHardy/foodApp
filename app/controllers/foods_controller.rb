class FoodsController < ApplicationController
  before_action :set_food, only: [:show]

  def index
    if params[:category_id].present?
      # Find by slug using FriendlyId
      @selected_category = Category.friendly.find_by(slug: params[:category_id])

      if @selected_category
        @foods = @selected_category.foods.includes(:categories, :reviews)
      else
        flash[:alert] = "Category not found"
        redirect_to root_path and return
      end
    else
      @foods = Food.includes(:categories, :reviews).all
    end
  end

  def show
    # @food is already set by set_food
    @reviews = @food.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
    @review = @food.reviews.new
  end

  private

  def set_food
    @food = Food.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to foods_path, alert: "Food not found."
  end
end
