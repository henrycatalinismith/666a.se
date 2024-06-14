class AddWordIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :translation_glossary_words, :word_text, unique: true
  end
end
