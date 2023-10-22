class SubscriptionType < ActiveRecord::Migration[7.1]
  def change
    rename_column :subscriptions, :status, :subscription_status
    add_column :subscriptions, :subscription_type, :integer
    add_column :subscriptions, :workplace_code, :string
  end
end
