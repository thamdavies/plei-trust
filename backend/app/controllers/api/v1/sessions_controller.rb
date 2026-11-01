module Api
  module V1
    class SessionsController < ApplicationController
      include Authentication

      skip_before_action :authenticate_api_token!, only: :create

      def create
        username = params[:username].to_s.strip.downcase
        password = params[:password].to_s

        if username.blank? || password.blank?
          @error = { code: "invalid_parameters", message: "Username and password are required" }
          render "api/v1/shared/error", status: :unprocessable_entity
        else
          authenticate_credentials(username, password)
        end
      end

      def destroy
        Current.api_token.revoke
        cookies.delete(:pawnify_session, path: "/api/v1") if @authenticating_via_cookie
        head :no_content
      end

      private

      def authenticate_credentials(username, password)
        attempt = LoginAttempt.for_username(username)

        if attempt.locked?
          retry_after = [(attempt.locked_until - Time.current).ceil, 1].max
          response.headers["Retry-After"] = retry_after.to_s
          @error = { code: "temporarily_limited", message: "Too many attempts. Try again later." }
          render "api/v1/shared/error", status: :too_many_requests
        else
          user = User.find_by(username: username)
          authenticated = user&.active? && user.authenticate(password)
          account = Account.find_by(slug: "pawnify") if authenticated
          membership = user&.memberships&.active&.includes(:account, :account_role)&.find_by(account: account) if account

          if authenticated && membership&.account_role&.scope_account?
            attempt.reset
            @api_token, @access_token = ApiToken.issue_for!(membership: membership)
            cookies[:pawnify_session] = session_cookie_options(@access_token, @api_token.expires_at)
            @user = user
            @account = membership.account
            @membership = membership
            render :create, status: :created
          else
            attempt.record_failure
            @error = { code: "invalid_credentials", message: "Username or password is incorrect" }
            render "api/v1/shared/error", status: :unauthorized
          end
        end
      end

      def session_cookie_options(value, expires_at)
        {
          value: value,
          expires: expires_at,
          httponly: true,
          same_site: :lax,
          secure: Rails.env.production?,
          path: "/api/v1",
        }
      end
    end
  end
end
