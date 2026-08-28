class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :code
      t.text :description
      t.date :published_date
      t.integer :pages
      t.string :language
      t.string :cover_url
      t.belongs_to :author, null: true, foreign_key: true

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE books
      ADD COLUMN status ENUM('public', 'private', 'deleted')
      NOT NULL DEFAULT 'public'
    SQL

    add_index :books, :code, unique: true
    add_index :books, :title, type: :fulltext
  end
end
