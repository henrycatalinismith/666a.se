class Metadata < ActiveRecord::Migration[7.1]
  def change
    create_table :metadata, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :result, null: false, type: :string, foreign_key: true
      t.string :name
      t.string :value
    end
  end
end
