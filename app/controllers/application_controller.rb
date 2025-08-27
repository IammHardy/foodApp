class ApplicationController < ActionController::Base
  helper_method :current_cart

  # Store user location before actions (for redirect after login)
  before_action :store_user_location!, if: :storable_location?
  before_action :load_food_subcategories
  before_action :load_main_categories

  # Devise redirect after sign in
  def after_sign_in_path_for(resource)
    merge_guest_cart_with(resource) if session[:cart_id]

    if resource.admin?
      admin_dashboard_path
    else
      stored_location_for(resource) || root_path
    end
  end

  # Current cart helper
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

  # Merge guest cart items into signed-in user's cart
  def merge_guest_cart_with(user)
    guest_cart = Cart.find_by(id: session[:cart_id])
    return unless guest_cart && guest_cart.user.nil?

    if user.cart
      guest_cart.cart_items.each do |item|
        existing_item = user.cart.cart_items.find_by(food_id: item.food_id)
        if existing_item
          existing_item.quantity += item.quantity
          existing_item.save
        else
          item.update(cart_id: user.cart.id)
        end
      end
      guest_cart.destroy
    else
      guest_cart.update(user: user)
    end

    session[:cart_id] = user.cart.id
  end

  # Determine if the current request URL should be stored for redirect
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  # Store the user location for Devise
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Load Food subcategories for header menu
  def load_food_subcategories
    food_category = Category.find_by(name: "Food")
    @food_subcategories = food_category ? food_category.children : []
  end

  # Load main categories for header menu
  def load_main_categories
    @main_categories = Category.where(parent_id: nil)
  end

  # Admin access check
  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
