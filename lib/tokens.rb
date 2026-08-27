module Tokens
  extend ActiveSupport::Concern

  class_methods do
    def revoke_all(user:)
      user.tokens.destroy_all
    end

    def create_tokens(user)
      user.tokens.create!
    end

    def access_token_expiry
      8.hours
    end
  end
end
