class AddRequestCountToDay < ActiveRecord::Migration[7.1]
  def change
    add_column :time_period_days, :request_count, :number
  end
end
