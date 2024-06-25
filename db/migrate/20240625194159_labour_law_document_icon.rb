class LabourLawDocumentIcon < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_documents, :document_icon, :string
  end
end
