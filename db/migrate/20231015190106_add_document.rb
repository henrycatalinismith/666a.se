class AddDocument < ActiveRecord::Migration[7.1]
  def change
    create_table :documents, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.string :document_code
      t.date :document_date
      t.integer :document_direction
      t.string :document_type
      t.string :case_code
      t.string :case_name
      t.integer :case_status
      t.string :company_code
      t.string :company_name
      t.string :workplace_code
      t.string :workplace_name
      t.string :county_code
      t.string :county_name
      t.string :municipality_code
      t.string :municipality_name
    end
    add_index :documents, :document_code, unique: true
  end
end
