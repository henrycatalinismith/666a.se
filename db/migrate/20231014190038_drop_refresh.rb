class DropRefresh < ActiveRecord::Migration[7.1]
  def change
    drop_table :refreshes
    drop_table :notifications
  end
end
