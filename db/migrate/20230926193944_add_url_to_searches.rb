class AddUrlToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :url, :string
  end
end
