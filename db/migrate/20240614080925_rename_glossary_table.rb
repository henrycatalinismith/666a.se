class RenameGlossaryTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :translation_glossary_words
    create_table :glossary_words, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :parent, index: true, type: :string, foreign_key: {
        to_table: :glossary_words,
      }
      t.string :word_text
      t.string :word_slug
      t.integer :word_type
    end
    add_index :glossary_words, :word_slug, unique: true
    add_index :glossary_words, :word_text, unique: true
  end
end
