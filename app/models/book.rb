class Book < ApplicationRecord
  belongs_to :author
  has_many :book_view
  has_many :user, through: :book_view
end
