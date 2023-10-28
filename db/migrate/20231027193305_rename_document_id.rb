class RenameDocumentId < ActiveRecord::Migration[7.1]
  def change
    rename_column :legal_revisions, :legal_document_id, :document_id
  end
end
