require "test_helper"

module Api
  module V1
    class MeControllerTest < ActionDispatch::IntegrationTest
      setup do
        @previous_frontend_origins = ENV["FRONTEND_ORIGINS"]
        ENV["FRONTEND_ORIGINS"] = "http://localhost:5173"
      end

      teardown do
        ENV["FRONTEND_ORIGINS"] = @previous_frontend_origins
      end

      test "current user accepts the browser session cookie" do
        token, raw_token = ApiToken.issue_for!(membership: memberships(:admin))

        get "/api/v1/me", headers: { "Cookie" => "pawnify_session=#{raw_token}" }

        assert_response :ok
        assert_equal users(:admin).id, response.parsed_body.dig("user", "id")
        assert_equal accounts(:pawnify).id, response.parsed_body.dig("account", "id")
        assert_equal "owner", response.parsed_body.dig("membership", "role")
        assert token.reload.last_used_at
      end

      test "current user preserves bearer token authentication" do
        token, raw_token = ApiToken.issue_for!(membership: memberships(:admin))

        get "/api/v1/me", headers: { "Authorization" => "Bearer #{raw_token}" }

        assert_response :ok
        assert_equal users(:admin).id, response.parsed_body.dig("user", "id")
        assert token.reload.last_used_at
      end

      test "current user rejects expired sessions" do
        _token, raw_token = ApiToken.issue_for!(membership: memberships(:admin), lifetime: -1.second)

        get "/api/v1/me", headers: { "Cookie" => "pawnify_session=#{raw_token}" }

        assert_response :unauthorized
        assert_equal "unauthorized", response.parsed_body.dig("error", "code")
      end

      test "current user rejects missing and inactive sessions" do
        get "/api/v1/me"
        assert_response :unauthorized

        token, raw_token = ApiToken.issue_for!(membership: memberships(:admin))
        token.revoke
        get "/api/v1/me", headers: { "Cookie" => "pawnify_session=#{raw_token}" }

        assert_response :unauthorized
        assert_equal "unauthorized", response.parsed_body.dig("error", "code")
      end
    end
  end
end
