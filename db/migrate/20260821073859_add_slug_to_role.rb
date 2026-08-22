class AddSlugToRole < ActiveRecord::Migration[8.1]
  def change
    add_column :roles, :slug, :string
  end
end
