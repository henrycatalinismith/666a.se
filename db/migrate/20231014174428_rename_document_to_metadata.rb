class RenameDocumentToMetadata < ActiveRecord::Migration[7.1]
  def change
    drop_table :documents
  end
end
