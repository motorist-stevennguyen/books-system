class AddCodeToBook < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :code, :string
    add_index :books, :code, unique: true
  end
end
