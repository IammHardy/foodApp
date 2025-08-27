class Admin::UsersController < Admin::BaseController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_user, only: [:show, :destroy]

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "You cannot delete yourself."
    elsif @user.destroy
      redirect_to admin_users_path, notice: "User deleted"
    else
      redirect_to admin_users_path, alert: "Failed to delete user"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
