class ApplicationController < ActionController::Base
  helper_method :current_user
  # logout
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    redirect_to login_url, alert: "Please log in." unless current_user
  end
end
