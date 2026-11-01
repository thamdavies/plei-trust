class RolePermission < ApplicationRecord
  belongs_to :account
  belongs_to :role
  belongs_to :permission

  validates :permission_id, uniqueness: { scope: :role_id }
  validate :role_belongs_to_account
  validate :only_assignable_permissions

  private

  def role_belongs_to_account
    errors.add(:role, "must belong to the same account") if role && role.account_id != account_id
  end

  def only_assignable_permissions
    errors.add(:permission, "must be an assignable action") if permission && !permission.assignable?
  end
end
