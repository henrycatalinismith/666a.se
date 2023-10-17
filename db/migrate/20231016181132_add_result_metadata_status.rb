class AddResultMetadataStatus < ActiveRecord::Migration[7.1]
  def change
    rename_column :results, :status, :metadata_status
    add_column :results, :document_status, :integer
    add_index :results, :metadata_status
    add_index :results, :document_status
  end
end
