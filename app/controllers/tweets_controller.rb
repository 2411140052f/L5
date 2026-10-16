class TweetsController < ApplicationController
  def create
    unless current_user
      redirect_to top_login_form_path, alert: "ツイートするにはログインしてください。"
      return
    end

    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      redirect_to root_path, notice: "ツイートしました。"
    else
      @tweets = Tweet.includes(:user, :likes).order(created_at: :desc)
      render "top/main", status: :unprocessable_entity
    end
  end

  def destroy
    unless current_user
      redirect_to top_login_form_path, alert: "ツイートを削除するにはログインしてください。"
      return
    end

    current_user.tweets.find(params[:id]).destroy!
    redirect_to root_path, notice: "ツイートを削除しました。"
  end

  private

  def tweet_params
    params.require(:tweet).permit(:message)
  end
end
