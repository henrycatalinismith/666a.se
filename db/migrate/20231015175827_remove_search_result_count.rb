class RemoveSearchResultCount < ActiveRecord::Migration[7.1]
  def change
    remove_column :searches, :result_count
  end
end
