class CreateGlossarySentence < ActiveRecord::Migration[7.1]
  def change
    create_table :glossary_sentences, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :element, index: true, type: :string, foreign_key: {
        to_table: :labour_law_elements
      }
      t.text :source_text
      t.text :target_text
    end
  end
end
