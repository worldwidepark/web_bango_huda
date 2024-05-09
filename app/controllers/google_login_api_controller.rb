class GoogleLoginApiController < ApplicationController
  require 'googleauth/id_tokens/verifier'

  protect_from_forgery except: :callback
  before_action :verify_g_csrf_token, only: :callback

  def callback
    payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV["GOOGLE_CLIENT_ID"])
    user = User.find_or_create_by(email: payload['email'])
    session[:user_id] = user.id
    redirect_to user_path, notice: 'ログインしました'
  end

  def logout
    reset_session
    redirect_to root_path, notice: 'ログアウトしました'
  end

  private

  def verify_g_csrf_token
    if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
      redirect_to root_path, notice: '不正なアクセスです'
    end
  end
end
# https://zenn.dev/yoiyoicho/articles/c44a80e4bb4515
