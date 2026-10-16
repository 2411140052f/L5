require "test_helper"

class SocialAppTest < ActionDispatch::IntegrationTest
  test "guests can read the timeline but do not see posting or like controls" do
    get root_path

    assert_response :success
    assert_select ".tweet-message", count: 2
    assert_select "form[action='/tweets']", count: 0
    assert_select "form[action^='/likes']", count: 0
  end

  test "users can register with unique ids and BCrypt passwords" do
    assert_difference("User.count", 1) do
      post users_path, params: {
        user: {
          uid: "new-user",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }
    end

    user = User.find_by!(uid: "new-user")
    assert BCrypt::Password.new(user.password_digest).is_password?("secret123")

    assert_no_difference("User.count") do
      post users_path, params: {
        user: {
          uid: "one",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "a logged-in user can post a tweet and add and remove likes" do
    post top_login_path, params: { uid: "one", password: "password" }
    assert_redirected_to root_path
    assert_equal "one", session[:login_uid]

    get root_path
    assert_response :success
    assert_select "form[action='/tweets']"
    assert_select "button", text: "いいね削除"
    assert_select "button", text: "いいね"

    assert_difference("Tweet.count", 1) do
      post tweets_path, params: { tweet: { message: "ログイン後の投稿" } }
    end

    other_tweet = tweets(:two)
    assert_difference("Like.count", 1) do
      post likes_path, params: { tweet_id: other_tweet.id }
    end

    like = users(:one).likes.find_by!(tweet: other_tweet)
    assert_difference("Like.count", -1) do
      delete like_path(like)
    end

    delete top_logout_path
    assert_nil session[:login_uid]
    post likes_path, params: { tweet_id: other_tweet.id }
    assert_redirected_to top_login_form_path
  end
end
