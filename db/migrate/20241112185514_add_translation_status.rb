class AddTranslationStatus < ActiveRecord::Migration[8.0]
  def change
    add_column :labour_law_elements, :translation_status, :integer
  end
end
