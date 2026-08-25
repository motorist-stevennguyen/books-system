module Authenticator
  extend ActiveSupport::Concern
  include Jwt

  class_methods do
    def authenticated(headers:, at: nil)
      token = at.presence || extract_header_token(headers: headers)
      raise BusinessException.new(ErrorMessages::AT_IS_MISSING) unless token.present?
      token_validate(token)
    end

    def token_validate(rt)
      raise BusinessException.new(ErrorMessages::RT_IS_MISSING) if rt.blank?

      existing_rt = Token.find_by_token(rt)
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN) unless existing_rt.present?
      User.find_by_id(id: existing_rt.user_id)
    end

    def extract_header_token(headers:)
      headers["Authorization"]&.split("Bearer ")&.last
    end

    def logout!(user:)
      revoke_all(user: user)
    end
  end
end
