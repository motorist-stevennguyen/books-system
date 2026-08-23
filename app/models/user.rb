class User < ApplicationRecord
  include RequiredNewUserValidator
  include Cacheable

  belongs_to :role

  scope :scp_by_id, -> (id) { where("id = ?", id) }
  scope :scp_by_email_or_username, -> (val) { where(username: val).or(where(email: val)) }

  has_many :book, through: :book_views
  has_many :book_views, dependent: :destroy

  has_many :refresh_tokens, dependent: :delete_all

  has_secure_password

  def self.find_by_email_or_username(val:, cacheable: false)
    if cacheable
      fetch("users:#{val}") do
        User.scp_by_email_or_username(val).first
      end
    else
      User.scp_by_email_or_username(val).first
    end
  end


  def self.find_by_id(id:, cacheable: false)
    if cacheable
      fetch("users:#{id}") do
        User.scp_by_id(id: id).first
      end
    else
      User.scp_by_id(id: id).first
    end
  end
end
