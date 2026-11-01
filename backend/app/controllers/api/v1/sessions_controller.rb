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
        head :no_content
      end

      private

      def authenticate_credentials(username, password)
        user = User.find_by(username: username)
        authenticated = user&.active? && user.authenticate(password)
        account = Account.find_by(slug: "pawnify") if authenticated
        membership = user&.memberships&.active&.includes(:account, :account_role)&.find_by(account: account) if account

        if authenticated && membership&.account_role&.scope_account?
          @api_token, @access_token = ApiToken.issue_for!(membership: membership)
          @user = user
          @account = membership.account
          @membership = membership
          render :create, status: :created
        else
          @error = { code: "invalid_credentials", message: "Username or password is incorrect" }
          render "api/v1/shared/error", status: :unauthorized
        end
      end

    end
  end
end
