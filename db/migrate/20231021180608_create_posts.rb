class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.string :title
      t.text :slug
      t.date :date
      t.string :body
    end
    add_index :posts, :slug, unique: true
    add_index :posts, :date
  end
end
