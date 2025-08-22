# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if session[:pending_cart_item]
      item = session.delete(:pending_cart_item)
      session[:cart] ||= {}
      session[:cart][item["food_id"].to_s] = session[:cart][item["food_id"].to_s].to_i + item["quantity"].to_i
      cart_path
    else
      super
    end
  end
end
