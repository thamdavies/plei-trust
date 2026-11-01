require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "derives all, partial, and none states from descendant action grants" do
    role = Role.create!(account: accounts(:pawnify), name: "Customer viewer", scope: :account)
    parent = permissions(:customers)
    phone_permission = permissions(:phone_view)
    identity_permission = permissions(:identity_view)

    assert_equal :none, role.permission_state_for(parent)

    RolePermission.create!(account: accounts(:pawnify), role: role, permission: phone_permission)
    assert_equal :partial, role.permission_state_for(parent)

    RolePermission.create!(account: accounts(:pawnify), role: role, permission: identity_permission)
    assert_equal :all, role.permission_state_for(parent)
  end

  test "does not allow grants on non-assignable group rows" do
    grant = RolePermission.new(account: accounts(:pawnify), role: roles(:owner), permission: permissions(:customers))

    refute grant.valid?
    assert_includes grant.errors[:permission], "must be an assignable action"
  end
end
