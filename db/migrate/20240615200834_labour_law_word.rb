class LabourLawWord < ActiveRecord::Migration[7.1]
  def change
    create_table :labour_law_words, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :sentence, index: true, type: :string, foreign_key: {
        to_table: :labour_law_sentences
      }
      t.text :source_word
      t.text :target_word
    end
  end
end
