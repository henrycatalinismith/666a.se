class Undo < ActiveRecord::Migration[7.1]
  def change
    drop_table :legal_documents
    create_table :legal_documents, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.string :document_name
      t.string :document_code
    end
    add_index :legal_documents, :document_code, unique: true
  end
end
