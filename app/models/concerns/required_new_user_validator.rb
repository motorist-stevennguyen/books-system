module RequiredNewUserValidator
  extend ActiveSupport::Concern
  included do
    validates :username, uniqueness: { case_sensitive: false }
    validates :email, email: true, uniqueness: { case_sensitive: false }
    
    validates_with RegisterValidator, if: :new_record?
  end
end
