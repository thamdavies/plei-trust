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
  rescue_from Errors::DailyBalanceNotFound, with: :handle_daily_balance_not_found

  def set_current_branch
    return unless signed_in?

    if Rails.env.development?
      ActsAsTenant.without_tenant do
        if DailyBalance.where(date: Date.current).count != Branch.count
          Branch.seed_daily_balances_for_all_branches
        end
      end
    end

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

  def daily_balance
    @daily_balance ||= begin
      record = current_branch.daily_balances.find_by(date: Date.current)
      raise Errors::DailyBalanceNotFound unless record

      record
    end
  end

  def handle_daily_balance_not_found
    flash[:error] = "Hệ thống đang xử lý quỹ tiền mặt, vui lòng thử lại sau."

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render json: { error: "Daily balance not found" }, status: :unprocessable_entity }
    end
  end
end
