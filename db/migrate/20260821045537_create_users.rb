class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :users, [ :email, :username, :first_name, :last_name ], type: :fulltext
  end
end
