module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_token!
  end

  private

  def authenticate_api_token!
    raw_token = request.authorization&.match(/\ABearer ([^\s]+)\z/i)&.captures&.first
    token = ApiToken.authenticate(raw_token)

    if token
      Current.api_token = token
      Current.user = token.user
      Current.account = token.account
      Current.membership = token.membership
      token.use
    else
      @error = { code: "unauthorized", message: "Authentication required" }
      render "api/v1/shared/error", status: :unauthorized
    end
  end
end
