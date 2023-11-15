class RemoveWeekStartAndEnd < ActiveRecord::Migration[7.1]
  def change
    remove_column :period_weeks, :week_start
    remove_column :period_weeks, :week_end
  end
end
