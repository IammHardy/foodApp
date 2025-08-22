class FoodsController < ApplicationController
 

  def index
    @foods = Food.includes(:reviews).all
  @main_categories = Category.where(parent_id: nil).includes(:children)
  @foods = Food.includes(:categories)
end

  def new
    @food = Food.new
    @categories = Category.all
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      redirect_to root_path, notice: "Food was sucessfully created."
    else
      @categories = Category.all
      render :new
  end
end
def edit
  @food = Food.find(params[:id])
  @categories = Category.all
end
def update
  @food = Food.find(params[:id])
  if @food.update(food_params)
    redirect_to root_path, notice: "Food was successfully updated."
  else
    @categories = Category.all
    render :edit
  end
end
def destroy
  @food = Food.find(params[:id])
  category_id = params[:category_id]

  @food.destroy

  if category_id.present?
    redirect_to category_path(category_id), notice: "Food deleted successfully."
  else
    redirect_to categories_path, notice: "Food deleted successfully."
  end
end



def show
 @food = Food.find(params[:id])
  @reviews = @food.reviews.order(created_at: :desc).page(params[:page]).per(5)
  @review = Review.new
end


private

def food_params
  params.require(:food).permit(:name, category_ids: [])
end

private
  def check_admin
  redirect_to root_path, alert: "Access denied." unless current_user&.admin?
end
end
