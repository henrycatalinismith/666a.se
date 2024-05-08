class LabourLawTranslationStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_translations, :translation_status, :integer
  end
end
