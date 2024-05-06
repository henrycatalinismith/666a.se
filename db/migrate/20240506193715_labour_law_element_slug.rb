class LabourLawElementSlug < ActiveRecord::Migration[7.1]
  def change
    rename_column :labour_law_elements, :element_code, :element_slug
  end
end
