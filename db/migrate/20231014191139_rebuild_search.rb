class RebuildSearch < ActiveRecord::Migration[7.1]
  def change
    drop_table :searches
    create_table :searches, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :day, null: false, type: :string, foreign_key: true
      t.integer :status
      t.string :hit_count
      t.integer :result_count
    end
  end
end
