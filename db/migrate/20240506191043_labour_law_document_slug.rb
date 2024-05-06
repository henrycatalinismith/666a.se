class LabourLawDocumentSlug < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_documents, :document_slug, :string
    add_index :labour_law_documents, :document_slug, unique: true
  end
end
