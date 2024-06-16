class LabourLawPhrase < ActiveRecord::Migration[7.1]
  def change
    drop_table :labour_law_words
    create_table :labour_law_phrases, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :sentence, index: true, type: :string, foreign_key: {
        to_table: :labour_law_sentences
      }
      t.text :source_phrase
      t.text :target_phrase
    end
  end
end
