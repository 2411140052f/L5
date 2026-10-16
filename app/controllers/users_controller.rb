class UsersController < ApplicationController
  def index
    @users = User.order(:id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "ユーザー登録が完了しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_user&.id == User.find(params[:id]).id
      redirect_to users_path, alert: "自分のアカウントのみ削除できます。"
      return
    end

    current_user.destroy!
    reset_session
    redirect_to users_path, notice: "ユーザーを削除しました。"
  end

  private

  def user_params
    params.require(:user).permit(:uid, :password, :password_confirmation)
  end
end
