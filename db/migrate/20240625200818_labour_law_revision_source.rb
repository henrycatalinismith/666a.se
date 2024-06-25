class LabourLawRevisionSource < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_revisions, :revision_source, :string
  end
end
