class RemoveElementLocale < ActiveRecord::Migration[7.1]
  def change
    remove_column :legal_elements, :element_locale
  end
end
