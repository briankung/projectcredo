class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :store_pre_signin_path

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def store_pre_signin_path
    return if !request.get? || request.xhr?

    user_paths = [
      "/users/sign_in",
      "/users/sign_up",
      "/users/password/new",
      "/users/password/edit",
      "/users/confirmation",
      "/users/sign_out"
    ]

    store_location_for(:user, request.fullpath) unless user_paths.include?(request.path)
  end

  private
    def ensure_current_user
      unless current_user
        flash[:alert] = 'You must sign in to perform this action'
        redirect_to new_user_session_path
      end
    end
end
