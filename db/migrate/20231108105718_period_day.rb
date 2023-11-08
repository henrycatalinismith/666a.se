class PeriodDay < ActiveRecord::Migration[7.1]
  def change
    rename_table :days, :period_days
  end
end
