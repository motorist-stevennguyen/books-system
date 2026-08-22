class AddEnableToRole < ActiveRecord::Migration[8.1]
  def change
    add_column :roles, :enable, :boolean
  end
end
