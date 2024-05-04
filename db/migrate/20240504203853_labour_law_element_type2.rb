class LabourLawElementType2 < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_elements, :element_type2, :integer, default: 0
  end
end
