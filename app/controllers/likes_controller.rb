class LikesController < ApplicationController
  def create
    unless current_user
      redirect_to top_login_form_path, alert: "いいねするにはログインしてください。"
      return
    end

    tweet = Tweet.find(params[:tweet_id])
    current_user.likes.find_or_create_by!(tweet:)
    redirect_to root_path, notice: "いいねしました。"
  end

  def destroy
    current_user.likes.find(params[:id]).destroy!
    redirect_to root_path, notice: "いいねを削除しました。"
  end
end
