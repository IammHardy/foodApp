class CartsController < ApplicationController
   before_action :authenticate_user!, only: [:checkout, :add_item, :remove_item]
  def create
    @cart = current_cart
    food = Food.find(params[:food_id])
    quantity = params[:quantity].to_i

    cart_item = @cart.cart_items.find_or_initialize_by(food: food)
    cart_item.quantity += quantity
    cart_item.save

    redirect_to cart_path, notice: "Item added to cart"
  end


def index
  @cart_items = current_user.cart_items.includes(:food)
end

  def show
  @cart = current_cart
  @cart_items = @cart.cart_items.includes(:food)
  @grand_total = @cart_items.sum { |item| item.food.price * item.quantity }
end


  def add_item
  @cart = current_cart
  food = Food.friendly.find(params[:id])
  quantity = params[:quantity].to_i
  quantity = 1 if quantity <= 0

  cart_item = @cart.cart_items.find_or_initialize_by(food: food)
  cart_item.quantity = (cart_item.quantity || 0) + quantity
  if cart_item.save
    redirect_to cart_path, notice: "#{food.name} added to cart."
  else
    redirect_to foods_path, alert: "Failed to add #{food.name} to cart."
  end
end

  def remove_item
    @cart = current_cart
    cart_item = @cart.cart_items.find_by(food_id: params[:id])
    cart_item.destroy if cart_item.present?
    redirect_to cart_path, notice: "Item removed."
  end

  def checkout
    @cart = current_cart
    @cart_items = @cart.cart_items.includes(:food)
    @grand_total = @cart_items.sum { |item| item.food.price * item.quantity }

    # For now:
    render :checkout
  end
end
