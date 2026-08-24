class Book < ApplicationRecord
  include Cacheable

  belongs_to :author
  has_many :book_view
  has_many :user, through: :book_view

  scope :scp_find_by_id, ->(id) { where(id: id) }
  scope :join_categories, -> { joins("LEFT JOIN categories cat ON cat.id = bc.category_id") }
  scope :join_book_categories, -> { joins("LEFT JOIN book_categories bc ON bc.book_id = #{table_name}.id") }
  scope :scp_book_category_ids, -> { joins("LEFT JOIN book_categories bc ON bc.book_id = #{table_name}.id").select("bc.category_id") }
  scope :scp_use_index, ->(index) { from("#{table_name} USE INDEX(#{index})") }

  def self.find_by_id(id:, cacheable: false)
    if cacheable
      fetch("books:#{id}") do
        Book.eager_load(:author).scp_use_index("index_books_on_title_and_description").scp_find_by_id(id).first
      end
    else
      Book.eager_load(:author).scp_use_index("index_books_on_title_and_description").scp_find_by_id(id).first
    end
  end

  def self.find_full_book(id)
    Book.scp_find_by_id(id).join_book_categories.join_categories.select('books.*, JSON_ARRAYAGG(JSON_OBJECT("id", cat.id, "name", cat.name)) as categories')
  end

  def self.find_book_categories(id)
    book_category_ids = Book.scp_find_by_id(id).scp_book_category_ids
    category_ids = book_category_ids.map do |item| item.category_id end
    Category.scp_find_by_ids(category_ids)
  end
end
