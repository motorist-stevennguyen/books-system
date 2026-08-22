class Role < ApplicationRecord
  has_many :permission, through: :role_permission
  has_many :role_permission, dependent: :destroy
end
