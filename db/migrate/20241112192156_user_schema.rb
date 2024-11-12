class UserSchema < ActiveRecord::Migration[8.0]
  def change
    drop_table :user_roles

    create_table :user_roles, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.string :name, null: false
      t.string :description, null: false
    end

    create_table :user_authorizations, id: false do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.references :account, index: true, type: :string, foreign_key: { to_table: :user_accounts }
      t.references :role, index: true, type: :string, foreign_key: { to_table: :user_roles } 
    end
  end
end
