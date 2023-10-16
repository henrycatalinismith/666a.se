class DropResult < ActiveRecord::Migration[7.1]
  def change
    drop_table :results
    drop_table :metadata
    create_table :metadata, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :search, null: false, type: :string, foreign_key: true
      t.string :document_code
      t.string :name
      t.string :value
    end
    create_table :parameters, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :search, null: false, type: :string, foreign_key: true
      t.string :name
      t.string :value
    end
  end
end
