class UsersController < ApplicationController
  before_action :authenticate_user

  def show
    @current_user = current_user
  end

  def edit
    @current_user = current_user
  end

  def update
    @current_user = current_user

    if @current_user.update(user_params)
      redirect_to user_path, notice: '成功: User情報アップデート'
    else
      render :edit
    end
  end

  def qr_code
    @store_name = current_user.store_name
    redirect_to user_path, alert: "店名を入力してください" if @store_name.blank?
    qrcode = RQRCode::QRCode.new("#{ENV["URL"]}/users/#{current_user.uuid}/bango_hudas/new")
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 10,
      standalone: true,
      use_path: true
    ).html_safe
  end

  private

  def user_params
    params.require(:user).permit(:store_name)
  end
end
