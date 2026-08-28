class Book < ApplicationRecord
  include Cacheable
  include Scopes

  belongs_to :author

  has_many :book_view, dependent: :nullify
  has_many :user, through: :book_view

  has_many :book_categories, dependent: :destroy
  has_many :category, through: :book_categories

  CODE_FORMAT = /\A[A-Z0-9]{8}\z/
  CODE_CHARS = ("A".."Z").to_a.concat(("0".."9").to_a) - %w[O 0 I 1]

  validates :code, presence: true, uniqueness: true, format: { with: CODE_FORMAT }
  validates :author, :category, :pages, presence: true
  validates :published_date, datetime: true
  validates :language, presence: true
  validates :pages, presence: true, numericality: { greater_than: 0 }

  before_validation :generate_code, on: :create

  scope :by_id, ->(id) { where(id: id) }
  scope :join_categories, -> { joins("LEFT JOIN categories cat ON cat.id = bc.category_id") }
  scope :join_book_categories, -> { joins("LEFT JOIN book_categories bc ON bc.book_id = #{table_name}.id") }

  scope :search_by_code, ->(keywords) { where("code LIKE ?", "#{keywords}%") }
  scope :search_by_author, ->(keywords) { where(author_id: Author.where("name LIKE ?", "#{keywords}%")) }
  scope :search_by_name, ->(keywords) { where("MATCH(title) AGAINST(? IN BOOLEAN MODE)", "#{keywords}*") }

  def self.find_by_id(id)
    exists = Book.by_id(id)
        .join_book_categories
        .join_categories
        .select("#{table_name}.*, JSON_ARRAYAGG(JSON_OBJECT('id', cat.id, 'name', cat.name)) as categories")
        .first
    raise BusinessException.new(ErrorMessages::RESOURCE_NOT_FOUND) if exists.id.nil?
    exists
  end

  def self.search(keywords)
    self.search_by_name(keywords).or(self.search_by_author(keywords)).or(self.search_by_code(keywords))
  end

  private
  def generate_code
    self.code ||= Array.new(8) { CODE_CHARS.sample }.join
  end
end
