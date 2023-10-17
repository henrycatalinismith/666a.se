class AddCompanyCodeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :company_code, :string
  end
end
