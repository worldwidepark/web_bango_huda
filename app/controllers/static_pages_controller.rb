class StaticPagesController < ApplicationController
  def before_login
    redirect_to user_path if session[:user_id].present?
  end
end
