class ApplicationController < ActionController::Base
  helper_method :current_cart

  before_action :store_user_location!, if: :storable_location?

  def after_sign_in_path_for(resource)
    # Merge guest cart into user cart
    if session[:cart_id]
      guest_cart = Cart.find_by(id: session[:cart_id])
      if guest_cart && guest_cart.user.nil?
        if resource.cart.present?
          guest_cart.cart_items.update_all(cart_id: resource.cart.id)
          guest_cart.destroy
        else
          guest_cart.update(user: resource)
        end
      end
    end

    # Redirect admin always to dashboard, no stored location
    if resource.admin?
      admin_dashboard_path
    else
      # Regular users: redirect to stored location or root
      stored_location_for(resource) || root_path
    end
  end

  def current_cart
    return @current_cart if defined?(@current_cart) && @current_cart.present?

    if session[:cart_id]
      @current_cart = Cart.find_by(id: session[:cart_id])
      return @current_cart if @current_cart
    end

    if current_user
      @current_cart = current_user.cart || current_user.create_cart
    else
      @current_cart = Cart.create
    end

    session[:cart_id] = @current_cart.id
    @current_cart
  end

  private

  def merge_guest_cart_with(user)
    return unless session[:cart_id]

    guest_cart = Cart.find_by(id: session[:cart_id])
    return unless guest_cart && guest_cart.user.nil?

    if user.cart
      # Move all guest cart items into user cart
      guest_cart.cart_items.each do |item|
        existing_item = user.cart.cart_items.find_by(food_id: item.food_id)
        if existing_item
          existing_item.quantity += item.quantity
          existing_item.save
        else
          item.cart_id = user.cart.id
          item.save
        end
      end
      guest_cart.destroy
    else
      # Assign guest cart to user if no user cart yet
      guest_cart.update(user: user)
    end

    session[:cart_id] = user.cart.id
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end
end
