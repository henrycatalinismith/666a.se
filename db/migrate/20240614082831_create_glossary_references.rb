class CreateGlossaryReferences < ActiveRecord::Migration[7.1]
  def change
    create_table :glossary_references, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :translation, index: true, type: :string, foreign_key: {
        to_table: :glossary_translations,
      }
      t.text :source_text
      t.text :target_text
    end
  end
end
