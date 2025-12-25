class Reports::DailyCashFlowsController < ApplicationController
  def index
    run(DailyCashFlow::Operations::Index, current_branch:, params: search_params) do |result|
      @form = result[:"contract.default"]
      @daily_flows = result[:daily_flows]
    end

    @summary = {
      opening_balance: @daily_flows.first&.opening_balance || 0,
      closing_balance: @daily_flows.last&.closing_balance || 0,
      opening_assets: @daily_flows.first&.opening_balance || 0,
      closing_assets: @daily_flows.last&.opening_balance || 0,
      difference: 0,
      profit: 0
    }

    if @daily_flows.any?
      @summary[:difference] = @summary[:closing_balance] - @summary[:opening_balance]
      @summary[:profit] = @summary[:closing_assets] - @summary[:opening_assets]
    end
  end

  private

  def search_params
    if params[:q].present? && (params.dig(:q, :date_gteq).present? || params.dig(:q, :date_lteq).present?)
      params.require(:q).permit(:date_gteq, :date_lteq)
    else
      params.permit({}).merge(q: { date_gteq: Date.current.beginning_of_month.to_fs(:date_vn), date_lteq: Date.current.to_fs(:date_vn) })
    end.to_h
  end
end
