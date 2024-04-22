class AccountId < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_roles, :user_id, :account_id
  end
end
