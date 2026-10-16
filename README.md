# つぶやきアプリ

## 起動方法

```sh
bundle install
bin/rails db:migrate
bin/rails server
```

ブラウザーで `http://localhost:3000` を開き、「ユーザー登録」からアカウントを作成します。ログインするとツイートの投稿と、各ツイートへのいいね・いいね削除ができます。パスワードは BCrypt でハッシュ化して保存されます。

## テスト

```sh
bin/rails test
```
