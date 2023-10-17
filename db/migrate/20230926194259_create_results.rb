class CreateResults < ActiveRecord::Migration[7.1]
  def change
    create_table :results, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :search, null: false, type: :string, foreign_key: true
      t.string :case_name
      t.string :company_code
      t.string :company_name
      t.string :document_code
      t.string :document_date
      t.string :document_type
    end
  end
end
