module Authenticator
  extend ActiveSupport::Concern
  include Jwt

  class_methods do
    def authenticated(headers:, at: nil)
      token = at.presence || extract_header_token(headers: headers)
      raise BusinessException.new(ErrorMessages::AT_IS_MISSING) unless token.present?

      decoded_token = decode!(token)
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN) if decoded_token.nil?

      user = token_validate(decoded_token)
      raise BusinessException.new(ErrorMessages::UNAUTHORIZED_ACCESS) unless user.present?

      [user, decoded_token]
    end

    def token_validate(decoded_token)
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN) unless decoded_token[:jti].present? && decoded_token[:uid].present?
      raise BusinessException.new(ErrorMessages::UNAUTHORIZED_ACCESS) if blacklisted?(jti: decoded_token[:jti])

      User.find_by_email_or_username(val: decoded_token[:"#{decoded_token[:start_session_by]}"], cacheable: true)
    end

    def extract_header_token(headers:)
      headers["Authorization"]&.split("Bearer ")&.last
    end

    def logout!(user:, decoded_token:)
      revoke(decoded_token: decoded_token, user: user)
    end
  end
end