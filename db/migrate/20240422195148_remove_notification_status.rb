class RemoveNotificationStatus < ActiveRecord::Migration[7.1]
  def change
    remove_column :work_environment_documents, :notification_status
  end
end
