class RenameDayStatus < ActiveRecord::Migration[7.1]
  def change
    rename_column :days, :status, :ingestion_status
  end
end
