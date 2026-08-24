class AddIndexToViewBook < ActiveRecord::Migration[8.1]
  def change
    add_index :book_views, [:book_id, :viewed_at]
    add_index :book_views, [:user_id, :viewed_at]
  end
end
