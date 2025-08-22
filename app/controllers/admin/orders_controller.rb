class Admin::OrdersController < Admin::BaseController

 def index
  search_params = params[:q]&.dup || {}

  if search_params["created_at_lteq"].present?
    begin
      search_params["created_at_lteq"] = Date.parse(search_params["created_at_lteq"]).end_of_day
    rescue ArgumentError
      search_params["created_at_lteq"] = nil
    end
  end

  @q = Order.ransack(search_params)
  @orders = @q.result.includes(:user).order(created_at: :desc).page(params[:page]).per(10)

  # Define stats
  @total_orders     = Order.count
  @pending_orders   = Order.where(status: 'pending').count
  @paid_orders      = Order.where(status: 'processing').count
  @total_revenue    = Order.where(status: 'processing').sum(:total_price) # or use your amount column
  @new_orders_today = Order.where(created_at: Time.zone.today.all_day).count

  # Notification updates
  @new_order_count = Order.where(seen_by_admin: false).count
  Order.where(seen_by_admin: false).update_all(seen_by_admin: true)

  respond_to do |format|
    format.html
    format.csv { send_data Order.to_csv(@q.result.includes(:user)), filename: "orders-#{Date.today}.csv" }
  end
end


  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to admin_orders_path, notice: "Order updated successfully."
    else
      redirect_to admin_orders_path, alert: "Failed to update order."
    end
  end

  def mark_paid
  @order = Order.find(params[:id])
  @order.update(status: "processing")
  redirect_to admin_order_path(@order), notice: "Order marked as paid."
end

def message_admin
  order = Order.find(params[:id])
  # Send WhatsApp + Email here (reuse your existing CallMeBot + mailer logic)
  AdminNotifier.send_order_ready_message(order)
  flash[:notice] = "Admin notified. You'll get a response soon."
  redirect_to order_path(order)
end


 def destroy
  @order = Order.find(params[:id])
  @order.destroy
  redirect_to admin_dashboard_path, notice: "Order was successfully deleted."
end


  private

  def order_params
    params.require(:order).permit(:status)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Access denied."
    end
  end
end
