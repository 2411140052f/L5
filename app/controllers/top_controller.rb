class TopController < ApplicationController
  def main
    @tweets = Tweet.includes(:user, :likes).order(created_at: :desc)
  end

  def login_form
  end

  def login
    user = User.find_by(uid: params[:uid])

    if user&.authenticate(params[:password])
      reset_session
      session[:login_uid] = user.uid
      redirect_to root_path, notice: "ログインしました。"
    else
      flash.now[:alert] = "ユーザーIDまたはパスワードが違います。"
      render :login_form, status: :unprocessable_entity
    end
  end

  def logout
    reset_session
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
