class AddCaseDateToDocument < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :case_date, :date
  end
end
