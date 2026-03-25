class Reports::TransactionSummaryController < ApplicationController
  add_breadcrumb "Báo cáo", :reports_transaction_summary_index_path

  def index
    add_breadcrumb "Tổng hợp giao dịch", :reports_transaction_summary_index_path

    run(::TransactionSummary::Operations::Index, current_branch:) do |result|
      @transaction_summary = result[:transaction_summary]
      @total_amount_in = result[:total_amount_in]
      @total_amount_out = result[:total_amount_out]
      @pagy, @transactions = pagy(result[:model])
    end
  end
end
