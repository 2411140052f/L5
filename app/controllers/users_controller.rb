class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update ]
  before_action :authorize_profile, only: [ :edit, :update ]

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

  def edit
  end

  def update
    if @user.update(profile_params)
      session[:login_uid] = @user.uid
      redirect_to root_path, notice: "プロフィールを更新しました。"
    else
      render :edit, status: :unprocessable_entity
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

  def profile_params
    params.require(:user).permit(:uid, :age)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_profile
    return if current_user&.id == @user.id

    redirect_to current_user ? root_path : top_login_form_path,
      alert: "自分のプロフィールのみ編集できます。"
  end
end
