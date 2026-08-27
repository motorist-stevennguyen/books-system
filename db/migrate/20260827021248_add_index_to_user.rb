class AddIndexToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_index :users, [ :email, :username, :first_name, :last_name ], type: :fulltext
  end
end
