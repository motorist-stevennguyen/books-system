class User < ApplicationRecord
  include Cacheable
  include Scopes

  has_secure_password

  attr_accessor :confirmation_password

  has_many :book, through: :book_views
  has_many :book_views, dependent: :destroy

  has_many :tokens, dependent: :destroy


  scope :scp_by_id, ->(id) { where(id: id) }
  scope :active, -> { where(status: StatusConst::ACTIVE) }
  scope :by_email_or_username, ->(val) { where(username: val).or(where(email: val)) }
  scope :search_by_username_email, ->(keywords) { where("MATCH(first_name, last_name, username, email) AGAINST(? IN BOOLEAN MODE)", "#{keywords}*") }

  validates :username, uniqueness: { case_sensitive: false }
  validates :email, email: true, uniqueness: { case_sensitive: false }
  validates_with RegisterValidator, if: :new_record?

  after_initialize :after_initial_callback, if: :new_record?


  def self.find_by_email_or_username(val:, cacheable: false)
    if cacheable
      fetch("#{table_name}:#{val}") do
        User.by_email_or_username(val).first
      end
    else
      User.by_email_or_username(val).first
    end
  end

  def self.search(keywords)
    User.search_by_username_email(keywords)
  end

  def self.find_by_id(id:, cacheable: false)
    if cacheable
      fetch("#{table_name}:#{id}") do
        User.scp_by_id(id).first
      end
    else
      User.scp_by_id(id).first
    end
  end

  private
  def after_initial_callback
    self.role ||= RoleConst::USER
  end
end
