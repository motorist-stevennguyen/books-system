class Author < ApplicationRecord
  has_many :book

  validates :name, presence: true
  validates :nationality, presence: true
  validates :bio, presence: true
  validates :birth_date, presence: true

  scope :search_by_name, ->(keywords, limit = 3) { where("name LIKE ?", keywords).limit(limit) }
end
