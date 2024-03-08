class BangoHudaController < ApplicationController
  # todo: login確認
  # todo: reset buttonを作る
  #
  def index
    current_user = User.find(params[:user_id])
    alive_bango_hudas = current_user.bango_hudas.where(is_showed: false).where(is_canceled: true).where(is_no_show: true)
  end
end
