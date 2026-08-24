class BookView < ApplicationRecord
  belongs_to :book
  belongs_to :user

  after_initialize :init_callback

  scope :scp_find_by_uid, ->(uid) { where(user_id: uid) }
  scope :load_book, -> { eager_load(:book) }
  scope :load_user, -> { eager_load(:user) }
  scope :viewed_at_before, ->(time) { where("viewed_at < ?", Time.new(time).utc.strftime("%FT%T")) }
  scope :viewed_at_after, ->(time) { where("viewed_at > ?", Time.new(time).utc.strftime("%FT%T")) }

  private
  def init_callback
    self.viewed_at = Time.now if new_record?
  end
end
