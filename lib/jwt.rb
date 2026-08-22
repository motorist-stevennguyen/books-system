class Jwt
  def self.decoded(token)
    body = JWT.decode(token, ENV["JWT_SECRET"])[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
  end
  def self.encoded(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, ENV["JWT_SECRET"])
  end
end
