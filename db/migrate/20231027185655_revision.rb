class Revision < ActiveRecord::Migration[7.1]
  def change
    create_table :legal_revisions, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :legal_document, null: false, type: :string, foreign_key: true
      t.string :revision_name
      t.string :revision_code
    end
    add_index :legal_revisions, :revision_code, unique: true
  end
end
