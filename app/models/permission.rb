class Permission < ApplicationRecord
  has_many :role, through: :role_permission
  has_many :role_permission, dependent: :destroy
end
