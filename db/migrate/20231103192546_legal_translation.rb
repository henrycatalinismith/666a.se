class LegalTranslation < ActiveRecord::Migration[7.1]
  def change
    create_table :legal_translations, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :legal_element, null: false, type: :string, foreign_key: true
      t.string :translation_locale
      t.string :translation_text
    end
    add_index :legal_translations, :translation_locale
  end
end
