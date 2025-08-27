class Admin::DashboardController < Admin::BaseController
  def index
    # Group by date
    @daily_sales = Order.group("DATE(created_at)").sum(:total_price)

    # Format for chart.js (labels + values)
    @daily_sales_chart = {
      labels: @daily_sales.keys.map { |d| d.strftime("%b %d") },
      data: @daily_sales.values
    }

    # Group by month
    @monthly_sales = Order.group("DATE_TRUNC('month', created_at)").sum(:total_price)

    @monthly_sales_chart = {
      labels: @monthly_sales.keys.map { |d| d.strftime("%B %Y") },
      data: @monthly_sales.values
    }

    # Unread notifications
    @unread_notifications = Notification.where(read: false).includes(:order)

    # Search and paginate orders
    @q = Order.ransack(params[:q])
    @orders = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(10)

    # Stats
    @total_orders     = Order.count
    @pending_orders   = Order.where(status: 'pending').count
    @paid_orders      = Order.where(status: 'processing').count
    @total_revenue    = Order.where(status: 'processing').sum(:total_price)
    @new_orders_today = Order.where(created_at: Time.zone.today.all_day).count

    # New order counter
    @new_order_count = Order.where(seen_by_admin: false).count
    Order.where(seen_by_admin: false).update_all(seen_by_admin: true)
  end
end
