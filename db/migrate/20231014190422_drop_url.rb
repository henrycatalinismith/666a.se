class DropUrl < ActiveRecord::Migration[7.1]
  def change
    remove_column :searches, :url
    add_column :searches, :result_count, :integer
  end
end
