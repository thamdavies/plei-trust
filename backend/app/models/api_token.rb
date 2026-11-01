require "digest"

class ApiToken < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :membership

  validates :token_digest, :expires_at, presence: true
  validates :token_digest, uniqueness: true
  validate :membership_matches_identity

  def self.issue_for!(membership:, raw_token: SecureRandom.urlsafe_base64(48), lifetime: default_lifetime)
    token = create!(
      account: membership.account,
      user: membership.user,
      membership: membership,
      token_digest: digest(raw_token),
      expires_at: Time.current + lifetime
    )

    [token, raw_token]
  end

  def self.authenticate(raw_token)
    token = find_by(token_digest: digest(raw_token)) if raw_token.present?
    token if token&.active?
  end

  def self.digest(raw_token)
    Digest::SHA256.hexdigest(raw_token)
  end

  def self.default_lifetime
    Integer(ENV.fetch("TOKEN_TTL_HOURS", "12")).hours
  end

  def active?
    revoked_at.nil? && expires_at.future? && membership.active? && user.active?
  end

  def use
    update_column(:last_used_at, Time.current)
  end

  def revoke
    update!(revoked_at: Time.current) if revoked_at.nil?
  end

  private

  def membership_matches_identity
    if membership && (membership.account_id != account_id || membership.user_id != user_id)
      errors.add(:membership, "must match token account and user")
    end
  end
end
