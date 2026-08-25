class Category < ApplicationRecord
  has_many :book, through: :book_category
  has_many :book_category, dependent: :nullify

  scope :by_id, ->(id) { where(id: id) }

  def self.find_by_id(id)
    Category.by_id(id).first
  end
end
