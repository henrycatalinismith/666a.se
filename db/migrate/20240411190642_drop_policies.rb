class DropPolicies < ActiveRecord::Migration[7.1]
  def change
    drop_table :policies
  end
end
