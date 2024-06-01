class LabourLawRevisionParentId < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_revisions, :parent_id, :string
  end
end
