class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pagy::Backend

  set_current_tenant_through_filter
  before_action :set_current_branch
  before_action :set_without_filter_form, if: -> { %w[new edit].include?(action_name) }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :require_login

  def set_current_branch
    return unless signed_in?

    branch_id = PleiTrust.redis.get(current_user.tenant_cache_key)
    @current_branch = if branch_id.present?
      Branch.find_by(id: branch_id) || current_user.branch
    else
      current_user.branch
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
end
