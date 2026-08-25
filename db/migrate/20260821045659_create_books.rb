class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_enum :book_status, %w[published archived draft]
    create_table :books do |t|
      t.string :title
      t.text :description
      t.date :published_date
      t.integer :pages
      t.string :language
      t.string :cover_url
      t.string :status, :book_status, default: "published"
      t.belongs_to :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
