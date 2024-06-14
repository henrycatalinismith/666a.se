class AddElementIdReference < ActiveRecord::Migration[7.1]
  def change
    add_reference :glossary_references, :element, type: :string, null: true, foreign_key: { to_table: :labour_law_elements }
  end
end
