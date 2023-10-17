class AddStatusToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :status, :integer, :default => 1
    add_index :subscriptions, :status
  end
end
