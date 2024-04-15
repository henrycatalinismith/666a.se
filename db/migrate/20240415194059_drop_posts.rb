class DropPosts < ActiveRecord::Migration[7.1]
  def changee
    drop_table :posts
  end
end
