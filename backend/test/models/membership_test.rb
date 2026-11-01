require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "allows only explicitly granted account permissions" do
    membership = memberships(:admin)

    assert membership.has_permission?("customers.phone.view")
    refute membership.has_permission?("pawn.contracts.view")
  end

  test "denies permissions to inactive membership" do
    membership = memberships(:admin)
    membership.update!(status: :suspended)

    refute membership.has_permission?("customers.phone.view")
  end

  test "store role applies only to its assigned store" do
    membership = memberships(:admin)
    assigned_store = stores(:one)
    other_store = Store.create!(account: accounts(:pawnify), code: "TWO", name: "Store Two")

    assert membership.has_permission?("pawn.contracts.view", store_id: assigned_store.id)
    refute membership.has_permission?("pawn.contracts.view", store_id: other_store.id)
  end

  test "derives parent permission state from action grants" do
    role = roles(:owner)
    parent = permissions(:customers)

    assert_equal :partial, role.permission_state_for(parent)

    RolePermission.create!(account: accounts(:pawnify), role: role, permission: permissions(:identity_view))
    assert_equal :all, role.permission_state_for(parent)
  end
end
