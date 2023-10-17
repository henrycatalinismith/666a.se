class UndoMultipleSearches < ActiveRecord::Migration[7.1]
  def change
    remove_reference :searches, :refresh
    add_reference :refreshes, :search, type: :string, foreign_key: true
  end
end
