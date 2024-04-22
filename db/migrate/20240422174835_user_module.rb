class UserModule < ActiveRecord::Migration[7.1]
  def change
    rename_table :users, :user_accounts
    rename_table :roles, :user_roles
  end
end
