class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def ensure_current_user
      unless current_user
        flash[:alert] = 'You must sign in to perform this action'
        redirect_to new_user_session_path
      end
    end
end
