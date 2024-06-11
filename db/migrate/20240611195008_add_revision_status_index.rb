class AddRevisionStatusIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :labour_law_revisions, [:document_id, :revision_code, :revision_status]
  end
end
