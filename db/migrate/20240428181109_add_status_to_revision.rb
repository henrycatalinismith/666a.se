class AddStatusToRevision < ActiveRecord::Migration[7.1]
  def change
    add_column :labour_law_revisions, :revision_status, :integer
  end
end
