class BangoHudasController < ApplicationController
  # todo: login確認
  before_action :check_session_availability, only: [:create, :index]
  before_action :set_count_bangohuda_created, only: [:create]
  before_action :authenticate_user,  only: [:index]
  before_action :find_bango_huda, only: [:no_show, :done, :cancel, :back_to_the_line]

  def index
    # adminと一般用を分ける。
    # store_nameがないと番号札の管理ができない
    if current_user.store_name.blank?
      flash[:alert] = "店名を入力してください"
      redirect_to edit_user_path
    end

    @current_user = current_user
    bangohudas = @current_user.bango_hudas.where(is_reseted: false)
    @alive_bango_hudas = bangohudas.select { |bango_huda| bango_huda.is_showed == false && bango_huda.is_canceled == false && bango_huda.is_no_show == false }
    @done_bango_hudas = bangohudas.select { |bango_huda| bango_huda.is_showed == true }
    @no_show_bango_hudas = bangohudas.select { |bango_huda| bango_huda.is_no_show == true }
    @canceled_bango_hudas = bangohudas.select { |bango_huda| bango_huda.is_canceled == true }

    # @alive_bango_hudas = Rails.cache.fetch("alive_bango_hudas", expires_in: 12.hours) do
    #   current_user.bango_hudas.where(is_showed: false, is_canceled: true, is_no_show: true)
    # end
  end

  def new
    current_user = User.find_by(uuid: params[:user_uuid])
    @store_name = current_user.store_name
    @waiting_people_count = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).where(is_reseted: false).size
  end

  def create
    # session_availableがfalseの場合は、セッションが有効ではないので、sessionを使わない
    # 1日10回以上の作成はできない
    if @session_available
      if @count_bangohuda_created >= 10
        flash[:alert] = "これ以上番号札の設定はできません。"
        redirect_to new_user_bango_huda_path
        return
      else
        increment_bangohuda_count
      end
    end
    current_user = User.find_by(uuid: params[:user_uuid])
    new_bango_huda = current_user.bango_hudas.new(bango: set_bango(current_user))
    if new_bango_huda.save
      flash[:notice] = "番号札作成完了"
      redirect_to user_bango_huda_path(user_uuid: new_bango_huda.user.uuid, uuid: new_bango_huda.uuid)
    else
      # 店の名前入れてあげると新設かも
      # ~店のstaffまで問い合わせしてください。みたいな
      flash[:alert] = "番号札作成に失敗しました。"
      render new_user_bango_huda_path
    end
  end

  def show
    @bango_huda = BangoHuda.find_by(uuid: params[:uuid])
    current_user = User.find_by(uuid: params[:user_uuid])
    @ordered_bango = current_user.bango_hudas.where(is_showed: false).where(is_canceled: false).where(is_no_show: false).where(is_reseted: false).order(bango: :asc).pluck(:bango)
    @waiting_count = @ordered_bango.index(@bango_huda.bango)
  end

  def delete
  end

  def no_show
    if  @bango_huda.update(is_no_show: true)
      flash[:notice] = "成功：不在"
      redirect_to bango_hudas_path
    else
      flash[:alert] = "失敗：不在"
      redirect_to bango_hudas_path
    end
  end

  def cancel
    if @bango_huda.update(is_canceled: true)
      flash[:notice] = "成功：キャンセル"
      redirect_to bango_hudas_path
    else
      flash[:alert] = "失敗：キャンセル"
      redirect_to bango_hudas_path
    end
  end

  def done
    if @bango_huda.update(is_showed: true)
      flash[:notice] = "成功：案内済み"
      redirect_to bango_hudas_path
    else
      flash[:alert] = "失敗：案内済み"
      redirect_to bango_hudas_path
    end
  end

  def back_to_the_line
    if @bango_huda.update(is_showed: false, is_canceled: false, is_no_show: false)
      flash[:notice] = "成功：再度待ち行列に戻す"
      redirect_to bango_hudas_path
    else
      flash[:alert] = "失敗：再度待ち行列に戻す"
      redirect_to bango_hudas_path
    end
  end

  def reset
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

  def find_bango_huda
    @bango_huda = BangoHuda.find(params[:id])
    unless @bango_huda
      flash[:alert] = "失敗：指定した番号札にエラーが発生しました。"
      redirect_to bango_hudas_path
    end
  end

  def set_count_bangohuda_created
    if @session_available
      session[:count_bangohuda_created] ||= 0
      @count_bangohuda_created = session[:count_bangohuda_created]
    end
  end

  def increment_bangohuda_count
    if @session_available
      session[:count_bangohuda_created] += 1
    end
  end
end

