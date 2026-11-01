class Role < ApplicationRecord
  belongs_to :account
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  has_many :memberships, foreign_key: :account_role_id, dependent: :restrict_with_exception
  has_many :store_memberships, dependent: :restrict_with_exception

  enum :scope, { account: "account", store: "store" }, prefix: true

  normalizes :name, with: ->(name) { name.strip }

  validates :name, :scope, presence: true
  validates :name, uniqueness: { scope: :account_id }

  def grants?(permission_key)
    permissions.where(key: permission_key, assignable: true).exists?
  end

  def permission_state_for(permission)
    keys = permission.descendant_action_permissions.map(&:key)
    granted_count = permissions.where(key: keys, assignable: true).count

    if granted_count.zero?
      :none
    elsif granted_count == keys.length
      :all
    else
      :partial
    end
  end
end
