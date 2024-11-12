class AddElementTextEn < ActiveRecord::Migration[8.0]
  def change
    add_column :labour_law_elements, :element_text_en, :text
  end
end
