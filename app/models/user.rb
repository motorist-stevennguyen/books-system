class User < ApplicationRecord
  include RequiredNewUserValidator

  belongs_to :role

  has_many :book, through: :book_review
  has_many :book_review, dependent: :destroy

  has_secure_password
end
