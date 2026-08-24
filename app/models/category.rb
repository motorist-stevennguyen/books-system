class Category < ApplicationRecord
  has_many :book, through: :book_category
  has_many :book_category, dependent: :nullify

  scope :scp_find_by_ids, ->(ids) { where(id: ids) }
end
