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
      t.belongs_to :author, null: false, foreign_key: true

      t.timestamps
    end

    add_column :books, :code, :string
    add_index :books, :code, unique: true
  end
end
