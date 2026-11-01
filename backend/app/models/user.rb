class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :restrict_with_exception
  has_many :accounts, through: :memberships
  has_many :api_tokens, dependent: :destroy

  enum :status, { active: "active", suspended: "suspended" }, default: :active

  normalizes :username, with: ->(username) { username.strip.downcase }

  validates :username, presence: true, uniqueness: true

  def active_for_authentication?
    active?
  end
end
