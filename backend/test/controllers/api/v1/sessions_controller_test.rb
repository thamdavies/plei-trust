require "test_helper"
require "time"

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @previous_frontend_origins = ENV["FRONTEND_ORIGINS"]
        ENV["FRONTEND_ORIGINS"] = "http://localhost:5173"
      end

      teardown do
        ENV["FRONTEND_ORIGINS"] = @previous_frontend_origins
      end

      test "sign-in returns a session context and an HttpOnly cookie without exposing the token" do
        prepare_auth_account

        post_session(username: " ADMIN ", password: "12345678")

        assert_response :created
        assert_equal %w[account membership user], response.parsed_body.keys.sort
        assert_equal "admin", response.parsed_body.dig("user", "username")
        assert_equal "pawnify", response.parsed_body.dig("account", "slug")
        refute response.parsed_body.key?("access_token")
        refute response.parsed_body.key?("token")

        cookie = response.headers.fetch("Set-Cookie")
        assert_match(/pawnify_session=[^;]+/, cookie)
        assert_match(/httponly/i, cookie)
        assert_match(/samesite=lax/i, cookie)
        assert_match(/path=\/api\/v1/i, cookie)

        raw_token = cookie.match(/pawnify_session=([^;]+)/)[1]
        token = ApiToken.find_by!(token_digest: ApiToken.digest(raw_token))
        assert_equal token.expires_at.to_i, Time.httpdate(cookie.match(/expires=([^;]+)/i)[1]).to_i
        refute_includes response.body, raw_token
      end

      test "sign-in requires a username and password" do
        post "/api/v1/session", params: { username: "admin" }, as: :json

        assert_response :unprocessable_entity
        assert_equal "invalid_parameters", response.parsed_body.dig("error", "code")
      end

      test "incorrect password and unknown username return the same generic error" do
        post_session(username: "admin", password: "incorrect")
        known_user_error = response.parsed_body
        assert_response :unauthorized
        assert_nil response.headers["Retry-After"]

        post_session(username: "nobody", password: "incorrect")

        assert_response :unauthorized
        assert_equal known_user_error, response.parsed_body
        assert_equal 1, LoginAttempt.find_by!(normalized_username: "admin").failed_attempts
        assert_equal 1, LoginAttempt.find_by!(normalized_username: "nobody").failed_attempts
      end

      test "suspended users and memberships cannot sign in" do
        prepare_auth_account
        users(:admin).update!(status: :suspended)

        post_session(username: "admin", password: "12345678")

        assert_response :unauthorized
        assert_equal "invalid_credentials", response.parsed_body.dig("error", "code")
        assert_nil response.headers["Retry-After"]

        users(:admin).update!(status: :active)
        memberships(:admin).update!(status: :suspended)
        post_session(username: "admin", password: "12345678")

        assert_response :unauthorized
        assert_equal "invalid_credentials", response.parsed_body.dig("error", "code")
      end

      test "the sixth attempt is temporarily limited after five consecutive failures" do
        5.times do
          post_session(username: "admin", password: "incorrect")
          assert_response :unauthorized
        end

        post_session(username: "admin", password: "incorrect")

        assert_response :too_many_requests
        assert_equal "temporarily_limited", response.parsed_body.dig("error", "code")
        assert_operator response.headers.fetch("Retry-After").to_i, :>, 0
        assert_operator response.headers.fetch("Retry-After").to_i, :<=, 15.minutes.to_i
      end

      test "a successful sign-in resets consecutive failures" do
        prepare_auth_account
        2.times { post_session(username: "admin", password: "incorrect") }
        assert_equal 2, LoginAttempt.find_by!(normalized_username: "admin").failed_attempts

        post_session(username: "admin", password: "12345678")

        assert_response :created
        attempt = LoginAttempt.find_by!(normalized_username: "admin")
        assert_equal 0, attempt.failed_attempts
        assert_nil attempt.locked_until
      end

      test "a failure after cooldown starts a new attempt window" do
        5.times { post_session(username: "admin", password: "incorrect") }
        attempt = LoginAttempt.find_by!(normalized_username: "admin")

        travel 16.minutes do
          post_session(username: "admin", password: "incorrect")
        end

        assert_response :unauthorized
        assert_equal 1, attempt.reload.failed_attempts
        assert_nil attempt.locked_until
      end

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

      def prepare_auth_account
        accounts(:pawnify).update!(slug: "pawnify")
      end

      def post_session(username:, password:)
        prepare_auth_account if username.strip.downcase == "admin" && password == "12345678"
        post "/api/v1/session", params: { username: username, password: password }, as: :json
      end

      def cookie_headers(raw_token, origin: "http://localhost:5173")
        {
          "Cookie" => "pawnify_session=#{raw_token}",
          "Origin" => origin,
        }
      end
    end
  end
end
