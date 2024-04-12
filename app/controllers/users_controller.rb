class UsersController < ApplicationController

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

  private

  def user_params
    params.require(:user).permit(:store_name)
  end
end
