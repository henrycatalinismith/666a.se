class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :searches, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.integer :status
      t.string :hit_count
    end

    change_table :refreshes do |t|
      t.references :search, null: false, type: :string, foreign_key: true
    end
  end
end
