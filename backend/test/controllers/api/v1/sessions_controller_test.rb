require "test_helper"

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      test "cookie sign-out revokes the token and clears the session cookie" do
        token, raw_token = ApiToken.issue_for!(membership: memberships(:admin))

        delete "/api/v1/session", headers: cookie_headers(raw_token)

        assert_response :no_content
        assert token.reload.revoked_at
        assert_match(/pawnify_session=;/, response.headers.fetch("Set-Cookie"))
        assert_match(/path=\/api\/v1/i, response.headers.fetch("Set-Cookie"))
      end

      test "sign-out requires an authenticated session" do
        delete "/api/v1/session", headers: { "Origin" => "http://localhost:5173" }

        assert_response :unauthorized
        assert_equal "unauthorized", response.parsed_body.dig("error", "code")
      end

      test "cookie sign-out rejects an untrusted origin without revoking the token" do
        token, raw_token = ApiToken.issue_for!(membership: memberships(:admin))

        delete "/api/v1/session", headers: cookie_headers(raw_token, origin: "https://attacker.example")

        assert_response :unauthorized
        assert token.reload.active?
      end

      test "bearer sign-out revokes the bearer token without clearing a browser cookie" do
        bearer_token, raw_bearer_token = ApiToken.issue_for!(membership: memberships(:admin))
        browser_token, raw_browser_token = ApiToken.issue_for!(membership: memberships(:admin))

        delete "/api/v1/session", headers: {
          "Authorization" => "Bearer #{raw_bearer_token}",
          "Cookie" => "pawnify_session=#{raw_browser_token}",
        }

        assert_response :no_content
        assert bearer_token.reload.revoked_at
        assert browser_token.reload.active?
        assert_nil response.headers["Set-Cookie"]
      end

      private

      def cookie_headers(raw_token, origin: "http://localhost:5173")
        {
          "Cookie" => "pawnify_session=#{raw_token}",
          "Origin" => origin,
        }
      end
    end
  end
end
