# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: "Google authentication failed."
      return
    end

    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: "Could not sign in via Google."
    end
  end
end
