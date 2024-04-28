class RenameLegalTranslations < ActiveRecord::Migration[7.1]
  def change
    rename_table :legal_translations, :labour_law_translations
  end
end
