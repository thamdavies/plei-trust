class StoreMembership < ApplicationRecord
  belongs_to :account
  belongs_to :membership
  belongs_to :store
  belongs_to :role

  validates :store_id, uniqueness: { scope: :membership_id }
  validate :records_share_account
  validate :role_is_store_scoped

  private

  def records_share_account
    errors.add(:account, "must match membership and store") if membership && store && (membership.account_id != account_id || store.account_id != account_id)
  end

  def role_is_store_scoped
    errors.add(:role, "must be store-scoped in this account") if role && (!role.scope_store? || role.account_id != account_id)
  end
end
