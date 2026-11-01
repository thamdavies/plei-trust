class Store < ApplicationRecord
  belongs_to :account
  has_many :store_memberships, dependent: :restrict_with_exception

  enum :status, { active: "active", suspended: "suspended" }, default: :active

  normalizes :code, with: ->(code) { code.strip.upcase }
  normalizes :name, with: ->(name) { name.strip }

  validates :code, :name, presence: true
  validates :code, uniqueness: { scope: :account_id }
end
