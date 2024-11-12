class RenameToElementTextSv < ActiveRecord::Migration[8.0]
  def change
    rename_column :labour_law_elements, :element_text, :element_text_sv
    change_column :labour_law_elements, :element_text_sv, :text
  end
end
