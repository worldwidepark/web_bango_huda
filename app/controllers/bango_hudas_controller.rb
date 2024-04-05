class BangoHudasController < ApplicationController
  # todo: login確認
  # todo: reset buttonを作る

  before_action :authenticate_user,  only: [:index]


  def index
    # adminと一般用を分ける。
    @current_user = current_user
    @alive_bango_hudas = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).where(is_reseted: false)
    @done_bango_hudas = current_user.bango_hudas.where(is_showed: true).where(is_reseted: false)
    @canceled_bango_hudas = current_user.bango_hudas.where(is_canceled: true).where(is_reseted: false)
    @no_show_bango_hudas = current_user.bango_hudas.where(is_no_show: true).where(is_reseted: false)
    # @alive_bango_hudas = Rails.cache.fetch("alive_bango_hudas", expires_in: 12.hours) do
    #   current_user.bango_hudas.where(is_showed: false, is_canceled: true, is_no_show: true)
    # end
  end

  def new
    current_user = User.find_by(uuid: params[:user_uuid])
    @waiting_people_count = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).where(is_reseted: false).size
  end

  def create
    current_user = User.find_by(uuid: params[:user_uuid])
    new_bango_huda = current_user.bango_hudas.new(bango: set_bango(current_user))
    #作成後、表示(show)
    # render "new"
    if new_bango_huda.save
      redirect_to user_bango_huda_path(user_uuid: new_bango_huda.user.uuid, id: new_bango_huda.id)
    else
      render new_user_bango_huda_path # fail文も
    # give bango_hudas Id to show
    end
  end

  def show
    @bango_huda = BangoHuda.find(params[:id])
    current_user = User.find_by(uuid: params[:user_uuid])
    @waiting_people_count = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).size
  end

  def delete
  end

  def no_show
    @bango_huda = BangoHuda.find(params[:id])
    if @bango_huda
      @bango_huda.update(is_no_show: true)
      redirect_to bango_hudas_path
    else
      render bango_hudas_path
    end
  end

  def cancel
    @bango_huda = BangoHuda.find(params[:id])
    if @bango_huda
      @bango_huda.update(is_canceled: true)
      redirect_to bango_hudas_path
    else
      render bango_hudas_path
    end
  end

  def done
    @bango_huda = BangoHuda.find(params[:id])
    if @bango_huda
      @bango_huda.update(is_showed: true)
      redirect_to bango_hudas_path
    else
      render bango_hudas_path
    end
  end

  def reset
    @alive_bango_hudas = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).where(is_reseted: false)
    unreseted_bango_hudas = current_user.bango_hudas.where(is_reseted: false)
    if unreseted_bango_hudas.update(is_reseted: true)
      redirect_to bango_hudas_path
    else
      render "index"
    end
  end

  private

  def set_bango(user)
    last_number = user.bango_hudas.where.not(is_reseted: true).maximum(:bango) || 0
    last_number + 1
  end
end

