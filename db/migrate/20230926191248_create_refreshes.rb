class CreateRefreshes < ActiveRecord::Migration[7.1]
  def change
    create_table :refreshes, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :subscription, null: false, type: :string, foreign_key: true
      t.integer :status
    end
  end
end
