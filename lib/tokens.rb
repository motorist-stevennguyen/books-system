module Tokens
  extend ActiveSupport::Concern
  include Cacheable

  class_methods do
    def revoke_all(user:)
      user.tokens.destroy_all
    end

    def create_tokens(user)
      access_token = user.tokens.create!
      access_token.token
    end

    def access_token_expiry
      8.hours
    end
  end
end
