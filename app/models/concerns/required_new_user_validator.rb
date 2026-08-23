module RequiredNewUserValidator
  extend ActiveSupport::Concern
  included do
    validates :password, password: true
    validates :email, email: true, uniqueness: { case_sensitive: false }
    validates :username, presence: true, uniqueness: { case_sensitive: false }, on: :create
  end
end
