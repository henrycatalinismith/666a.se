class LabourLawElementChapter < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_elements, :element_chapter, :string
    add_column :labour_law_elements, :element_section, :string
    add_column :labour_law_elements, :element_paragraph, :string
  end
end
