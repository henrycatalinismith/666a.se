class LegalElement < ActiveRecord::Migration[7.1]
  def change
    create_table :legal_elements, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :legal_revision, null: false, type: :string, foreign_key: true
      t.string :element_type
      t.string :element_locale
      t.string :element_code
      t.string :element_text
    end
    add_index :legal_elements, :element_code
    remove_index :legal_revisions, :revision_code
    add_index :legal_revisions, :revision_code
  end
end
