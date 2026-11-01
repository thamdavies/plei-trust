require "test_helper"

class ApiTokenTest < ActiveSupport::TestCase
  test "issues opaque bearer token and stores only its digest" do
    token, raw_token = ApiToken.issue_for!(membership: memberships(:admin), lifetime: 1.hour)

    refute_equal raw_token, token.token_digest
    assert_equal Digest::SHA256.hexdigest(raw_token), token.token_digest
    assert_equal token, ApiToken.authenticate(raw_token)
    assert_nil ApiToken.authenticate("not-a-valid-token")
  end

  test "revoked and expired tokens cannot authenticate" do
    membership = memberships(:admin)
    revoked_token, raw_revoked_token = ApiToken.issue_for!(membership: membership)
    revoked_token.revoke
    expired_token, raw_expired_token = ApiToken.issue_for!(membership: membership, lifetime: -1.second)

    assert_nil ApiToken.authenticate(raw_revoked_token)
    assert_nil ApiToken.authenticate(raw_expired_token)
    assert_not expired_token.active?
  end
end
