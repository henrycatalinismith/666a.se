class DeleteResult < ActiveRecord::Migration[7.1]
  def change
    drop_table :work_environment_results
  end
end
