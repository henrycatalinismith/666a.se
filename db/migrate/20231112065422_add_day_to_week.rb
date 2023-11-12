class AddDayToWeek < ActiveRecord::Migration[7.1]
  def change
    add_reference :period_days, :period_week, index: true, foreign_key: true
    #rename_column :period_days, :period_week_id, :week_id
  end
end
