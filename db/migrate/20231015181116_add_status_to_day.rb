class AddStatusToDay < ActiveRecord::Migration[7.1]
  def change
    add_column :days, :status, :integer
  end
end
