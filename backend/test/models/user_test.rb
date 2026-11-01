require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes username and authenticates against password digest" do
    user = User.create!(username: " New Admin ", password: "correct horse battery")

    assert_equal "new admin", user.username
    refute_equal "correct horse battery", user.password_digest
    assert user.authenticate("correct horse battery")
    refute user.authenticate("incorrect")
  end

  test "suspended users are not active for authentication" do
    user = users(:admin)
    user.update!(status: :suspended)

    refute user.active_for_authentication?
  end
end
