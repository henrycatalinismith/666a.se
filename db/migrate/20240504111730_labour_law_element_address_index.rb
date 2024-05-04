class LabourLawElementAddressIndex < ActiveRecord::Migration[7.1]
  def change
    add_index(:labour_law_elements, [
      :revision_id,
      :element_chapter,
      :element_section,
      :element_paragraph,
    ])
  end
end
