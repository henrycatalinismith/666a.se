class LabourLawElementType < ActiveRecord::Migration[7.1]
  def change
    remove_column :labour_law_elements, :element_type
    rename_column :labour_law_elements, :element_type2, :element_type
  end
end
