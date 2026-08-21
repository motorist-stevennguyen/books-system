class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :status
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
