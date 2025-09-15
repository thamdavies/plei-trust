class CurrentTenantController < ApplicationController
  def update
    return if params[:branch_id] == current_branch.id.to_s

    run(Tenant::Operations::Switch, user: current_user, branch_id: params[:branch_id]) do |result|
      redirect_to root_path, notice: "Đã chuyển sang #{result[:branch].name}"
    end
  end
end
