class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  def index
  if params[:search].present?
    query = "%#{params[:search]}%"
    @categories = Category.joins(:foods)
                          .where("categories.name ILIKE ? OR foods.name ILIKE ?", query, query)
                          .distinct
  else
    @categories = Category.all
  end
  
end


  def new
    @category = Category.new
  end
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to root_path, notice: "Category was successfully created."
    else
      render :new
    end
  end
  def show
  @category = Category.includes(:foods).find(params[:id])
end
def destroy
  @category = Category.find(params[:id])
  @category.destroy
  redirect_to root_path, notice: "Category deleted!"
end


  private
  def category_params
    params.require(:category).permit(:name)
  end
  private
  def check_admin
  redirect_to root_path, alert: "Access denied." unless current_user&.admin?
end
end
