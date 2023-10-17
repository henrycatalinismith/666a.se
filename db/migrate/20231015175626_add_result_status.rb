class AddResultStatus < ActiveRecord::Migration[7.1]
  def change
    drop_table :results
    create_table :results, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :search, null: false, type: :string, foreign_key: true
      t.integer :status
      t.string :document_code
      t.string :case_name
      t.string :document_type
      t.string :document_date
      t.string :organisation_name
      t.string :metadata
    end
  end
end
