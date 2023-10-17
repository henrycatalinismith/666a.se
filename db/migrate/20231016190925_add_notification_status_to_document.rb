class AddNotificationStatusToDocument < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :notification_status, :integer
    add_index :documents, :notification_status
  end
end
