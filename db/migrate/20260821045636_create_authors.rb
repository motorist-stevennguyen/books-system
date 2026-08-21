class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :bio
      t.date :birth_date
      t.string :nationality

      t.timestamps
    end
  end
end
