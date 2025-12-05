class DashboardController < ApplicationController
  before_action :set_without_filter_form

  def index
    run(Dashboard::Operations::Index, current_branch:) do |result|
      @dashboard_data = result[:dashboard_data]
    end
  end
end
