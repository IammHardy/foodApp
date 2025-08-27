class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]  # Only admin actions require login
  before_action :check_admin, except: [:show, :index]

  # GET /categories
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

  # GET /categories/:id
  def show
    @category = Category.friendly.find_by(slug: params[:id])
    if @category
      @foods = @category.foods
    else
      redirect_to categories_path, alert: "Sorry, this category does not exist."
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category created successfully."
    else
      render :new
    end
  end

  # DELETE /categories/:id
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: "Category deleted!"
  end

  private

  def category_params
    params.require(:category).permit(:name, :slug, :description, :parent_id)
  end

  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
