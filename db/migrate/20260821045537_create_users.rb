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


    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, [ :first_name, :last_name ], type: :fulltext

    execute <<-SQL
        ALTER TABLE users
        ADD COLUMN status ENUM('active', 'deleted')
        NOT NULL DEFAULT 'active'
      SQL

    execute <<-SQL
      ALTER TABLE users
      ADD COLUMN role ENUM('user', 'admin', 'member')
      NOT NULL DEFAULT 'user'
    SQL
  end
end
