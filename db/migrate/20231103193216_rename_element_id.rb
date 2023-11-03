class RenameElementId < ActiveRecord::Migration[7.1]
  def change
    rename_column :legal_translations, :legal_element_id, :element_id
  end
end
