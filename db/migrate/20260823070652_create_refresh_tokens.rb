class CreateRefreshTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :crypted_token
      t.datetime :expires_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
