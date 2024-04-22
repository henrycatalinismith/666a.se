class AccountId2 < ActiveRecord::Migration[7.1]
  def change
    rename_column :user_subscriptions, :user_id, :account_id
  end
end
