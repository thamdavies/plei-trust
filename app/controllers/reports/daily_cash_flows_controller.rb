class Reports::DailyCashFlowsController < ApplicationController
  def index
    # Sample data structure - replace with actual implementation
    @daily_flows = generate_sample_data
    @summary = {
      opening_balance: @daily_flows.first&.dig(:opening_balance) || 0,
      closing_balance: @daily_flows.last&.dig(:closing_balance) || 0,
      opening_assets: @daily_flows.first&.dig(:total_assets) || 0,
      closing_assets: @daily_flows.last&.dig(:total_assets) || 0,
      difference: 0,
      profit: 0
    }

    if @daily_flows.any?
      @summary[:difference] = @summary[:closing_balance] - @summary[:opening_balance]
      @summary[:profit] = @summary[:closing_assets] - @summary[:opening_assets]
    end
  end

  private

  def report_params
    params.permit(:start_date, :end_date, :branch_id)
  end

  def generate_sample_data
    # This is sample data - replace with actual query
    start_date = params[:start_date]&.to_date || Date.current.beginning_of_month
    end_date = params[:end_date]&.to_date || Date.current

    (start_date..end_date).map do |date|
      {
        date: date.strftime("%d/%m/%Y"),
        opening_balance: 30_206_283_210,
        pawn: 0,
        credit: 0,
        installment: -5_500_000,
        income_expense: 1_121_212,
        capital: 0,
        closing_balance: 30_201_904_422,
        pawn_receivable: 35_028_222,
        credit_receivable: 0,
        installment_receivable: 30_000_000,
        capital_payable: 828_641_414,
        total_assets: 29_438_291_230
      }
    end
  end
end
