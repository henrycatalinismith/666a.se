class CreateLegalDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :legal_documents do |t|
      t.string :document_name
      t.string :document_code

      t.timestamps
    end
    add_index :legal_documents, :document_code, unique: true
  end
end
