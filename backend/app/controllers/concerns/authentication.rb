module Authentication
  extend ActiveSupport::Concern

  included do
    include ActionController::Cookies
    before_action :authenticate_api_token!
  end

  private

  def authenticate_api_token!
    bearer_token = request.authorization&.match(/\ABearer ([^\s]+)\z/i)&.captures&.first
    @authenticating_via_cookie = bearer_token.blank? && cookies[:pawnify_session].present?
    raw_token = bearer_token.presence || cookies[:pawnify_session]

    if raw_token.present? && cookie_request_is_trusted_origin?
      token = ApiToken.authenticate(raw_token)

      if token
        Current.api_token = token
        Current.user = token.user
        Current.account = token.account
        Current.membership = token.membership
        token.use
      else
        authentication_required
      end
    else
      authentication_required
    end
  end

  def cookie_request_is_trusted_origin?
    return true if request.authorization.present? || request.get? || request.head?

    origin = request.headers["Origin"]
    allowed_origins = ENV.fetch("FRONTEND_ORIGINS", "http://localhost:5173,http://127.0.0.1:5173")
      .split(",")
      .map(&:strip)

    origin.present? && (origin == request.base_url || allowed_origins.include?(origin))
  end

  def authentication_required
    @error = { code: "unauthorized", message: "Authentication required" }
    render "api/v1/shared/error", status: :unauthorized
  end
end
