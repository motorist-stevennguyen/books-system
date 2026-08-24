class RenameRefreshTokenToToken < ActiveRecord::Migration[8.1]
  def change
    rename_table :refresh_tokens, :tokens
  end
end
