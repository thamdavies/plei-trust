class Reports::TransactionSummaryController < ApplicationController
  add_breadcrumb "Báo cáo", :reports_transaction_summary_index_path

  def index
    add_breadcrumb "Tổng hợp giao dịch", :reports_transaction_summary_index_path

    run(::TransactionSummary::Operations::Index, current_branch:) do |result|
      @transactions = result[:transactions]
    end
  end
end
