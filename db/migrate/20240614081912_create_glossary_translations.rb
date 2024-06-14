class CreateGlossaryTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :glossary_translations, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :word, index: true, type: :string, foreign_key: {
        to_table: :glossary_words,
      }
      t.string :translation_text
    end
    add_index :glossary_translations, :translation_text
  end
end
