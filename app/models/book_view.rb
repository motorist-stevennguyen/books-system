class BookView < ApplicationRecord
  include Scopes

  belongs_to :book
  belongs_to :user

  scope :by_uid, ->(uid) { where(user_id: uid) }
  scope :by_id, ->(id) { where(id: id) }
  scope :load_user, -> { eager_load(:user) }
  scope :load_book, -> { eager_load(:book).where("books.status = ?", StatusConst::PUBLIC) }
  scope :viewed_at_before, ->(time) { where("created_at < ?", Time.new(time).utc.strftime("%FT%T")) }
  scope :viewed_at_after, ->(time) { where("created_at > ?", Time.new(time).utc.strftime("%FT%T")) }
  scope :clear_history, ->(user_id) { where(user_id: user_id).delete_all }
  scope :search, ->(keywords) { where(book_id: Book.search(keywords)) }
end
