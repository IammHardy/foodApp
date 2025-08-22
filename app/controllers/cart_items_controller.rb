class CartItemsController < ApplicationController
  def create
    cart = current_cart
    food = Food.find(params[:food_id])
    quantity = params[:quantity].to_i

    cart_item = cart.cart_items.find_by(food_id: food.id)
    if cart_item
      cart_item.quantity += quantity
    else
      cart_item = cart.cart_items.build(food: food, quantity: quantity)
    end

    if cart_item.save
      redirect_to cart_path, notice: "Item added to cart."
    else
      redirect_to root_path, alert: "Could not add item to cart."
    end
  end

  

  def update
    cart_item = CartItem.find(params[:id])
    if cart_item.update(quantity: params[:quantity])
      redirect_to cart_path, notice: "Item updated."
    else
      redirect_to cart_path, alert: "Could not update item."
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Item removed."
  end
end
