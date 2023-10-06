class RoleProps < ActiveRecord::Migration[7.1]
  def change
    change_table :roles do |t|
      t.integer :name
      t.references :user, null: false, type: :string, foreign_key: true
    end
  end
end
