class PeriodWeek < ActiveRecord::Migration[7.1]
  def change
    create_table :period_weeks, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.date :week_start
      t.date :week_end
      t.string :week_code
    end
    add_index :period_weeks, :week_code
  end
end
