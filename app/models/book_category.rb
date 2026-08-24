class BookCategory < ApplicationRecord
  belongs_to :book
  belongs_to :category

  scope :find_by_book_id, ->(book_id) { where(book_id: book_id) }
  scope :join_categories, -> { joins("LEFT JOIN categories cat ON cat.id = #{table_name}.category_id") }

  def self.find_categories_by_book(book_id)
    BookCategory.find_by_book_id(book_id).join_categories.select("cat.*")
  end
end
