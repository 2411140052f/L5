class AddAuthenticationToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :uid, :string
    add_index :users, :uid, unique: true
    add_column :users, :password_digest, :string
  end
end
