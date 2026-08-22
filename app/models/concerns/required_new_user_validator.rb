module RequiredNewUserValidator
  extend ActiveSupport::Concern
  included do
    validate :password, password: true
    validate :email, email: true
  end
end
