class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @food = Food.find(params[:food_id])
    @review = @food.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to food_path(@food), notice: "Review added successfully."
    else
      redirect_to food_path(@food), alert: "Failed to add review."
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
