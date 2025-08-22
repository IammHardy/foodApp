class Admin::DashboardController < Admin::BaseController
  def index
    @daily_sales = Order.group_by_day(:created_at).sum(:total_price)
    @monthly_sales = Order.group_by_month(:created_at).sum(:total_price)
    @unread_notifications = Notification.where(read: false).includes(:order)


  @q = Order.ransack(params[:q])
  @orders = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(10)
  
 # Define stats
  @total_orders     = Order.count
  @pending_orders   = Order.where(status: 'pending').count
  @paid_orders      = Order.where(status: 'processing').count
  @total_revenue    = Order.where(status: 'processing').sum(:total_price) # or use your amount column
  @new_orders_today = Order.where(created_at: Time.zone.today.all_day).count

  @new_order_count = Order.where(seen_by_admin: false).count
  Order.where(seen_by_admin: false).update_all(seen_by_admin: true)
end

end
