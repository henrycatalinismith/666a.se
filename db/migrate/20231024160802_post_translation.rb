class PostTranslation < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :body, :body_en
    add_column :posts, :body_sv, :string
  end
end
