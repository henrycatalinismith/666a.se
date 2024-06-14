class CreateTranslationGlossaryWord < ActiveRecord::Migration[7.1]
  def change
    create_table :translation_glossary_words, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :parent, index: true, type: :string, foreign_key: {
        to_table: :translation_glossary_words,
      }
      t.string :word_text
      t.string :word_slug
      t.integer :word_type
    end
    add_index :translation_glossary_words, :word_slug, unique: true
  end
end
