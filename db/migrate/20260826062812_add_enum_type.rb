class AddEnumType < ActiveRecord::Migration[8.1]
  def change
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

    execute <<-SQL
      ALTER TABLE books
      ADD COLUMN status ENUM('public', 'private', 'deleted')
      NOT NULL DEFAULT 'public'
    SQL
  end
end
