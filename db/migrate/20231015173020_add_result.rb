class AddResult < ActiveRecord::Migration[7.1]
  def change
    drop_table :searches
    drop_table :metadata
    drop_table :parameters

    create_table :searches, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :day, null: false, type: :string, foreign_key: true
      t.integer :page_number
      t.integer :status
      t.string :hit_count
      t.integer :result_count
    end

    create_table :results, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :search, null: false, type: :string, foreign_key: true
      t.string :document_code
      t.string :case_name
      t.string :document_type
      t.string :document_date
      t.string :organisation_name
    end
  end
end
