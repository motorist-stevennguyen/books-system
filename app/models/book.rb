class Book < ApplicationRecord
  include Cacheable

  belongs_to :author
  has_many :book_view
  has_many :user, through: :book_view

  scope :by_id, ->(id) { where(id: id) }
  scope :join_categories, -> { joins("LEFT JOIN categories cat ON cat.id = bc.category_id") }
  scope :join_book_categories, -> { joins("LEFT JOIN book_categories bc ON bc.book_id = #{table_name}.id") }
  scope :use_index, -> { from("#{table_name} USE INDEX(index_books_on_title_and_description)") }
  scope :search, ->(keywords) { where("MATCH(title, description) AGAINST(? IN BOOLEAN MODE)", "#{keywords}*") }

  def self.find_by_id(id)
    exists = Book.by_id(id)
        .use_index
        .join_book_categories
        .join_categories
        .select("#{table_name}.*, JSON_ARRAYAGG(JSON_OBJECT('id', cat.id, 'name', cat.name)) as categories")
        .first
    raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND) if exists.id.nil?
    exists
  end
end
