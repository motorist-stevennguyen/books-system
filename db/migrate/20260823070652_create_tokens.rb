class CreateTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :tokens do |t|
      t.string :hashed_token
      t.datetime :expires_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tokens, :hashed_token, unique: true
  end
end
