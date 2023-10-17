class Notification < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :document, null: false, type: :string, foreign_key: true
      t.references :subscription, null: false, type: :string, foreign_key: true
      t.integer :email_status
    end
    add_index :notifications, [:document_id, :subscription_id], unique: true
  end
end
