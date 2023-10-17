class RenameSearchStatus < ActiveRecord::Migration[7.1]
  def change
    rename_column :searches, :status, :result_status
  end
end
