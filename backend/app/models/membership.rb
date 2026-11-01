class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :user
  belongs_to :account_role, class_name: "Role", optional: true
  has_many :store_memberships, dependent: :destroy
  has_many :api_tokens, dependent: :destroy

  enum :status, { active: "active", suspended: "suspended" }, default: :active

  validates :user_id, uniqueness: { scope: :account_id }
  validate :account_role_matches_account

  def has_permission?(permission_key, store_id: nil)
    allowed = false

    if active? && account_role&.scope_account? && account_role.grants?(permission_key)
      allowed = true
    elsif active? && store_id.present?
      store_membership = store_memberships.includes(:role, :store).find_by(account_id: account_id, store_id: store_id)
      allowed = store_membership&.store&.active? && store_membership.role&.scope_store? && store_membership.role.grants?(permission_key)
    end

    !!allowed
  end

  def effective_permissions
    role_ids = []
    role_ids << account_role_id if active? && account_role&.scope_account?
    role_ids.concat(store_memberships.includes(:role).select { |assignment| assignment.role&.scope_store? }.map(&:role_id)) if active?

    Permission.joins(:role_permissions)
      .where(role_permissions: { account_id: account_id, role_id: role_ids }, assignable: true)
      .distinct
      .order(:key)
  end

  private

  def account_role_matches_account
    errors.add(:account_role, "must be account-scoped in this account") if account_role && (!account_role.scope_account? || account_role.account_id != account_id)
  end
end
