class UserSubscription < ActiveRecord::Migration[7.1]
  def change
    rename_table :work_environment_notifications, :user_notifications
    rename_table :work_environment_subscriptions, :user_subscriptions
  end
end
