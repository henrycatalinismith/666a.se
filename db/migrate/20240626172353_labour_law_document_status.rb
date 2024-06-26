class LabourLawDocumentStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_documents, :document_status, :integer, default: 0
    add_index :labour_law_documents, :document_status
  end
end
