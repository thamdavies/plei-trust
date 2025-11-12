class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Method
  include Pundit::Authorization

  set_current_tenant_through_filter

  before_action :set_current_branch
  before_action :set_without_filter_form, if: -> { %w[new edit].include?(action_name) }
  before_action :set_paper_trail_whodunnit

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :require_login

  rescue_from Pundit::NotAuthorizedError, with: :handle_pundit_not_authorized

  def set_current_branch
    return unless signed_in?

    branch_id = PleiTrust.redis.get(current_user.tenant_cache_key)
    @current_branch = if branch_id.present?
      Branch.find_by(id: branch_id) || current_user.branch
    else
      current_user.branch
    end

    if @current_branch.inactive?
      sign_out
      redirect_to sign_in_path, alert: "Chi nhánh hiện tại đã bị vô hiệu hóa. Vui lòng liên hệ quản trị viên để biết thêm chi tiết."
      return
    end

    set_current_tenant(@current_branch)
  end

  helper_method :current_branch

  def current_branch
    @current_branch
  end

  def set_without_filter_form
    @without_filter_form = true
  end

  def handle_pundit_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash.now[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
  end
end
