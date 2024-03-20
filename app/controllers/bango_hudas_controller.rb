class BangoHudasController < ApplicationController
  # todo: login確認
  # todo: reset buttonを作る

  before_action :authenticate_user,  only: [:index]

  def index
    # admin
    @current_user = current_user.email
    # @alive_bango_hudas = current_user.bango_hudas.where(is_showed: false).where(is_canceled: true).where(is_no_show: true)
    # @alive_bango_hudas = Rails.cache.fetch("alive_bango_hudas", expires_in: 12.hours) do
    #   current_user.bango_hudas.where(is_showed: false, is_canceled: true, is_no_show: true)
    # end
  end

  def new
    # user, user_idは暗号化要
    current_user = User.find(params[:user_id])
    @waiting_people_count = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).size
  end

  def create
    current_user = User.find(params[:user_id])
    # 番号入力要
    new_bango_huda = current_user.bango_hudas.new(bango: set_bango(current_user))
    #作成後、表示(show)
    if new_bango_huda.save
      redirect_to user_bango_huda_path(user_id: new_bango_huda.user_id, id: new_bango_huda.id)

    else
      render new_user_bango_huda_path # fail文も
    # give bango_hudas Id to show
    end
  end

  def show
    @bango_huda = BangoHuda.find(params[:id])
    current_user = User.find(params[:user_id])
    @waiting_people_count = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).size
  end

  def delete
  end

  private

  def set_bango(user)
    last_number = user.bango_hudas.where.not(is_reseted: true).maximum(:bango) || 0
    last_number + 1
  end
end

