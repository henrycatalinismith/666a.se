class TableNames < ActiveRecord::Migration[7.1]
  def change
    rename_table :documents, :work_environment_documents
    rename_table :results, :work_environment_results
    rename_table :notifications, :work_environment_notifications
    rename_table :searches, :work_environment_searches
    rename_table :subscriptions, :work_environment_subscriptions
  end
end
