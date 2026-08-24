class Token < ApplicationRecord
  include Cacheable
  include Jwt

  belongs_to :user
  before_create :set_crypted_token

  attr_accessor :token

  scope :active, -> {where("expires_at > ?", Time.now)}
  scope :by_crypted_token, ->(crypted_token) {where(crypted_token: crypted_token)}

  def self.find_by_token(raw_token)
    return nil if raw_token.blank?
    crypted = Digest::SHA256.hexdigest(raw_token)
    active.by_crypted_token(crypted).first
  end

  private
  def set_crypted_token
    self.token = SecureRandom.hex(32)
    self.crypted_token = Digest::SHA256.hexdigest(token)
    self.expires_at ||= self.class.access_token_expiry.from_now
  end
end
