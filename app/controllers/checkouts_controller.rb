class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_cart
    @order = current_user.orders.build
  end

  def create
  @order = current_user.orders.new(order_params)
  @order.status = "pending"

  if @order.save
    current_cart.cart_items.each do |item|
      @order.order_items.create(
        food: item.food,
        quantity: item.quantity,
        price: item.food.price || 0
      )
    end

    # 🔥 IMPORTANT: Update total_price AFTER creating order_items
    total = @order.order_items.sum { |i| i.quantity * i.price }
    @order.update(total_price: total)

    current_cart.cart_items.destroy_all
    redirect_to order_path(@order), notice: "Order placed successfully."
  else
    render :new
  end
end




  private

  def order_params
  params.require(:order).permit(:name, :address, :phone)
end
end
