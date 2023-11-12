class RenameWeekId < ActiveRecord::Migration[7.1]
  def change
    rename_column :period_days, :period_week_id, :week_id
  end
end
