class MultipleSearches < ActiveRecord::Migration[7.1]
  def change
    remove_reference :refreshes, :search
    add_reference :searches, :refresh, type: :string, foreign_key: true
  end
end
