class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :refresh, null: false, type: :string, foreign_key: true
      t.references :result, null: false, type: :string, foreign_key: true
      t.integer :email_status
    end
  end
end
