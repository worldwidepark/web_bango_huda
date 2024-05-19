class ApplicationController < ActionController::Base
  before_action :check_session_availability
  helper_method :current_user

  private

  def current_user
    if @session_available
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    else
      nil
    end
  end

  def authenticate_user
    unless @session_available
      redirect_to root_path, alert: "セッションが有効ではありません。"
    end
    unless current_user
      redirect_to root_path, alert: "ログインしてください。"
    end
  end

  def check_session_availability
    if session[:session_available].nil?
      begin
        session[:session_available] = true
        @session_available = true
      rescue ActionDispatch::Cookies::CookieOverflow
        @session_available = false
        session.delete(:session_available)
      end
    else
      @session_available = session[:session_available]
    end
  end
end
