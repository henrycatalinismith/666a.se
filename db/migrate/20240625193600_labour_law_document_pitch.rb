class LabourLawDocumentPitch < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_documents, :document_pitch, :text
  end
end
