# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "rails/all"
User.destroy_all
RolePermission.destroy_all
Role.destroy_all
Permission.destroy_all


admin_role_id = 0
user_role_id = 0

roles = []
[
  { name: "Admin", slug: "admin" },
  { name: "User", slug: "user" }
].each do |role|
  created = Role.create(name: role[:name], slug: role[:slug], enable: true)
  roles << created
  if role[:slug] == "admin"
    admin_role_id = created.id
  else
    user_role_id = created.id
  end
end

User.create(email: "stevennguyen@motorist.com", password: "123Steven", username: "stevennguyen", role_id: admin_role_id)
perms = [
  { resource: "user", action: PermissionEnum::CREATE, role_id: user_role_id },
  { resource: "user", action: PermissionEnum::UPDATE, role_id: admin_role_id },
  { resource: "user", action: PermissionEnum::READ, role_id: user_role_id },
  { resource: "user", action: PermissionEnum::DELETE, role_id: user_role_id },

  { resource: "role", action: PermissionEnum::CREATE, role_id: admin_role_id },
  { resource: "role", action: PermissionEnum::UPDATE, role_id: admin_role_id },
  { resource: "role", action: PermissionEnum::READ, role_id: admin_role_id },
  { resource: "role", action: PermissionEnum::DELETE, role_id: admin_role_id },

  { resource: "permission", action: PermissionEnum::CREATE, role_id: admin_role_id },
  { resource: "permission", action: PermissionEnum::UPDATE, role_id: admin_role_id },
  { resource: "permission", action: PermissionEnum::READ, role_id: admin_role_id },
  { resource: "permission", action: PermissionEnum::DELETE, role_id: admin_role_id },

  { resource: "book", action: PermissionEnum::CREATE, role_id: admin_role_id },
  { resource: "book", action: PermissionEnum::UPDATE, role_id: admin_role_id },
  { resource: "book", action: PermissionEnum::READ, role_id: admin_role_id },
  { resource: "book", action: PermissionEnum::DELETE, role_id: admin_role_id }
]

perms.each do |resource|
  perm = Permission.create(slug: "#{resource[:action]}_#{resource[:resource]}", name: "#{resource[:action].upcase} #{resource[:resource].upcase}")
  resource[:id] = perm.id
end

perms.each do |perm|
   RolePermission.create(role_id: perm[:role_id], permission_id: perm[:id])
end
