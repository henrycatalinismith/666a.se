class DeleteTranslations < ActiveRecord::Migration[8.0]
  def change
    drop_table :labour_law_translations
  end
end
