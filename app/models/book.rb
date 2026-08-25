class Book < ApplicationRecord
  include Cacheable

  belongs_to :author
  has_many :book_view
  has_many :user, through: :book_view

  CODE_FORMAT = /\A[A-Z0-9]{8}\z/
  CODE_CHARS = ("A".."Z").to_a.concat(("0".."9").to_a) - %w[O 0 I 1]
  validates :code, presence: true, uniqueness: true, format: { with: CODE_FORMAT }
  before_validation :generate_code, on: :create

  scope :by_id, ->(id) { where(id: id) }
  scope :join_categories, -> { joins("LEFT JOIN categories cat ON cat.id = bc.category_id") }
  scope :join_book_categories, -> { joins("LEFT JOIN book_categories bc ON bc.book_id = #{table_name}.id") }
  scope :use_index, -> { from("#{table_name} USE INDEX(index_books_on_title_and_description)") }
  scope :search, ->(keywords) {
    next all if keywords.blank?

    # if keywords.length == 8 && keywords.match?(/\A[A-Z0-9]{8}\z/i)
    #   code_matches = where(code: keywords.upcase)
    #   next code_matches if code_matches.exists?
    # end

    if keywords.length >= 4 && keywords.match?(/\A[A-Z0-9]+\z/i)
      code_matches = where("code LIKE ?", "#{keywords.u pcase}%")
      next code_matches if code_matches.exists?
    end

    sanitized = keywords.gsub(/[+\-<>()~*"@]/, " ").strip
    where("MATCH(title, description) AGAINST(? IN BOOLEAN MODE)", "#{sanitized}*")
  }

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
  private
  def generate_code
    self.code ||= Array.new(8) { CODE_CHARS.sample }.join
  end
end
