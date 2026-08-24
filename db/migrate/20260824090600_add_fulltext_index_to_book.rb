class AddFulltextIndexToBook < ActiveRecord::Migration[8.1]
  def change
    add_index :books, [ :title, :description ], type: :fulltext
  end
end
