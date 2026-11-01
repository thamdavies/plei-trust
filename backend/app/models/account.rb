class Account < ApplicationRecord
  has_many :memberships, dependent: :restrict_with_exception
  has_many :users, through: :memberships
  has_many :roles, dependent: :restrict_with_exception
  has_many :stores, dependent: :restrict_with_exception

  normalizes :name, with: ->(name) { name.strip }
  normalizes :slug, with: ->(slug) { slug.strip.downcase }

  validates :name, :slug, :currency, presence: true
  validates :slug, uniqueness: true
end
