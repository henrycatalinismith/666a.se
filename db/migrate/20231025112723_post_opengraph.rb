class PostOpengraph < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :description, :string
  end
end
