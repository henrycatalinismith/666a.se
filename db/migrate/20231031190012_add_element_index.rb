class AddElementIndex < ActiveRecord::Migration[7.1]
  def change
    add_column :legal_elements, :element_index, :number
    add_index :legal_revisions, :element_index
    add_index :legal_revisions, :element_locale
  end
end
