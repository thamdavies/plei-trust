class AddAccountRoleToMemberships < ActiveRecord::Migration[8.1]
  def change
    add_reference :memberships, :account_role, type: :uuid
  end
end
