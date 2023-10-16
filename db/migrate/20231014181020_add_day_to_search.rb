class AddDayToSearch < ActiveRecord::Migration[7.1]
  def change
    add_reference :searches, :day, null: false, foreign_key: true
  end
end
