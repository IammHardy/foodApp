class Admin::CategoriesController < Admin::BaseController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_category, only: [:edit, :update, :destroy, :show]

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
      redirect_to admin_categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully."
    else
      render :edit
    end
  end

  def show
    # Already handled by before_action
  end

 def destroy
  @category = Category.find(params[:id])

  if @category.children.any? || @category.foods.any?
    redirect_to admin_categories_path, alert: "Cannot delete category with subcategories or foods."
  else
    @category.destroy
    redirect_to admin_categories_path, notice: "Category deleted!"
  end
end


  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
