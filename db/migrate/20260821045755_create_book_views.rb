class CreateBookViews < ActiveRecord::Migration[8.1]
  def change
    create_table :book_views do |t|
      t.belongs_to :book, null: true, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
