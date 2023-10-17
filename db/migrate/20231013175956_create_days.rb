class CreateDays < ActiveRecord::Migration[7.1]
  def change
    create_table :days, id: false  do |t|
      t.primary_key :id, :string, default: -> { "ULID()" }
      t.timestamps
      t.date :date
    end
    add_index :days, :date, unique: true
  end
end
