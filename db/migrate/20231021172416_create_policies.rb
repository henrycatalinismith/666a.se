class CreatePolicies < ActiveRecord::Migration[7.1]
  def change
    create_table :policies, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.string :name
      t.string :icon
      t.text :slug
      t.string :body
    end
    add_index :policies, :slug, unique: true
  end
end
