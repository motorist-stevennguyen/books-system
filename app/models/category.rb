class Category < ApplicationRecord
  has_many :book, through: book_category
  has_many :book_category, dependent: :nullify
end
