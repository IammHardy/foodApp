class Admin::FoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  def index
    @foods = Food.all
  end

  def new
    @food = Food.new
    @categories = Category.all
  end

 def create
  @food = Food.new(food_params.except(:image))
  if @food.save
    if food_params[:image].present?
      @food.image.attach(food_params[:image])
      @food.save  # Save again after attaching image
    end
    redirect_to admin_foods_path, notice: "Food was successfully created."
  else
    @categories = Category.all
    render :new
  end
end


  def edit
    @categories = Category.all
  end

  def update
  if @food.update(food_params.except(:image))
    if food_params[:image].present?
      @food.image.purge if @food.image.attached?
      @food.image.attach(food_params[:image])
      @food.save
    end
    redirect_to admin_foods_path, notice: "Food was successfully updated."
  else
    @categories = Category.all
    render :edit
  end
end


  def destroy
    @food.destroy
    redirect_to admin_foods_path, notice: "Food deleted successfully."
  end

  def show
  end

  private

  def set_food
    @food = Food.find(params[:id])
  end

  def food_params
  params.require(:food).permit(:name, :description, :price, :image, category_ids: [])
end


  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
