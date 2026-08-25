class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_enum :user_role, %w[user member admin]
    create_enum :user_status, %w[active deleted]
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :status, :user_status, default: "active"
      t.string :role, :user_role, default: "user"

      t.timestamps
    end
  end
end
