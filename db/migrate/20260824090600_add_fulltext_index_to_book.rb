class AddFulltextIndexToBook < ActiveRecord::Migration[8.1]
  def change
    add_index :books, :title, type: :fulltext
  end
end
