class ChangeWeekIdToString < ActiveRecord::Migration[7.1]
  def change
    change_column :period_days, :week_id, :string
  end
end
