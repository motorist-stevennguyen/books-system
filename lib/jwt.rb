module Jwt
  extend ActiveSupport::Concern
  include Cacheable

  class_methods do
    def revoke(user:)
      user.tokens.destroy_all
    rescue => e
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN)
    end

    def revoke_all(user:)
      user.tokens.destroy_all
    end

    def create_tokens(user)
      access_token = user.tokens.create!
      access_token.token
    end

    def access_token_expiry
      15.minutes
    end
  end
end