class RenameLegalToLabourLaw < ActiveRecord::Migration[7.1]
  def change
    rename_table :legal_documents, :labour_law_documents
    rename_table :legal_revisions, :labour_law_revisions
    rename_table :legal_elements, :labour_law_elements
  end
end
