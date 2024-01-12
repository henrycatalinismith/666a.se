class RenamePeriodDaysToTimePeriodDays < ActiveRecord::Migration[7.1]
  def change
    rename_table :period_days, :time_period_days
    rename_table :period_weeks, :time_period_weeks
  end
end
