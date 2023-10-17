class Role < ActiveRecord::Migration[7.1]
  def change
    create_table :roles, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps null: false
      t.references :user, null: false, type: :string, foreign_key: true
      t.integer :name
    end
  end
end
