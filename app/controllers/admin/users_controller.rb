class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      redirect_to admin_users_path, notice: "User deleted"
    else
      redirect_to admin_users_path, alert: "Failed to delete user"
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
