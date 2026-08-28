class Author < ApplicationRecord
  has_many :book, dependent: :nullify

  validates :name, presence: true
  validates :nationality, presence: true
  validates :bio, presence: true
  validates :birth_date, presence: true

  scope :search_by_name, ->(keywords, limit = 3) { where("name LIKE ?", "#{keywords}%").limit(limit) }
  scope :by_id, ->(id) { where(id: id) }

  def self.find_by_id(id)
    Author.by_id(id).first
  end
end
