class AddIndexToAuthor < ActiveRecord::Migration[8.1]
  def change
    add_index :authors, :name
  end
end
