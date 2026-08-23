module Jwt
  extend ActiveSupport::Concern
  include Cacheable

  class_methods do
    def decode(token,verify_expiry: true)
      opts = {  verify_iat: true }
      opts[:verify_expiration] = false unless verify_expiry

      decoded = JWT.decode(token, ENV["JWT_SECRET"], true, opts)[0]
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN) unless decoded.present?

      decoded.symbolize_keys
    rescue StandardError => e
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN)
    end

    def decode!(token, verify_expiry: true)
      decode(token, verify_expiry: verify_expiry)
    rescue StandardError => e
      nil
    end
    def encode(user)
      jti = SecureRandom.uuid
      issued_at = Time.now
      exp = (issued_at + access_token_expiry).to_i

      uid = user.fetch("id")
      username = user.fetch("username")
      email = user.fetch("email")

      at = JWT.encode({ jti: jti, iat: issued_at.to_i, exp: exp, uid: uid, email: email, username: username, start_session_by: user[:start_session_by]}, ENV["JWT_SECRET"])
      [at, jti, exp]
    end

    def blacklist!(jti:, exp:)
      ttl  = [exp - Time.now.to_i, 1].max
      set(CacheKey::JWT_BLACKLIST + jti, jti, ttl)
    end

    def blacklisted?(jti:)
      exists?(CacheKey::JWT_BLACKLIST + jti)
    end

    def revoke(decoded_token:, user:)
      jti = decoded_token.fetch(:jti)
      exp = decoded_token.fetch(:exp)

      blacklist!(jti: jti, exp: exp)
      user.refresh_tokens.destroy_all
    rescue => e
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN)
    end

    def revoke_all(user:)
      user.refresh_tokens.destroy_all
    end

    def refresh!(rt:, at: , user:)
      raise BusinessException.new(ErrorMessages::RT_IS_MISSING) if rt.blank?
      raise BusinessException.new(ErrorMessages::AT_IS_MISSING) if at.blank?

      decoded_at = decode!(at, verify_expiry: false)
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN) unless decoded_at[:uid] == user.id

      existing_rt = user.refresh_tokens.find_by_token(rf)
      raise BusinessException.new(ErrorMessages::INVALID_TOKEN) if existing_rt.present?
      existing_rt.destroy!
      blacklist!(jti: decoded_at[:jti], exp: decoded_at[:exp])

      new_at, new_rt = create_tokens(user: user)

      [new_at, new_rt]
    end

    def create_tokens(user, login_with = "username")
        access_token, _jti, _exp = encode({ **user.as_json, start_session_by: login_with })
      refresh_token = user.refresh_tokens.create!

      [access_token, refresh_token.token]
    end

    def access_token_expiry
      15.minutes
    end

    def refresh_token_expiry
      30.days
    end
  end
end