class NullableSearch < ActiveRecord::Migration[7.1]
  def change
    change_column_null :refreshes, :search_id, true
  end
end
