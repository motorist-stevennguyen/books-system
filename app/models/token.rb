class Token < ApplicationRecord
  include Cacheable
  include Tokens

  belongs_to :user
  before_create :set_hashed_token

  attr_accessor :token

  scope :active, -> { where("expires_at > ?", Time.now) }
  scope :by_hashed_token, ->(hashed_token) { where(hashed_token: hashed_token) }

  def self.find_by_token(raw_token)
    return nil if raw_token.blank?
    hashed = Digest::SHA256.hexdigest(raw_token)
    active.eager_load(:user).by_hashed_token(hashed).first
  end

  private
  def set_hashed_token
    self.token = SecureRandom.hex(32)
    self.hashed_token = Digest::SHA256.hexdigest(token)
    self.expires_at ||= self.class.access_token_expiry.from_now
  end
end
