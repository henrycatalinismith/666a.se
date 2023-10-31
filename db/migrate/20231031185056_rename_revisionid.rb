class RenameRevisionid < ActiveRecord::Migration[7.1]
  def change
    rename_column :legal_elements, :legal_revision_id, :revision_id
  end
end
