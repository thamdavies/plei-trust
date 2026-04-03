class Reports::TransactionSummaryController < ApplicationController
  layout -> { params[:printable].present? ? "blank" : "application" }

  add_breadcrumb "Báo cáo", :reports_transaction_summary_index_path

  def index
    add_breadcrumb "Tổng hợp giao dịch", :reports_transaction_summary_index_path

    run(::TransactionSummary::Operations::Index, current_branch:) do |result|
      @summary = result[:transaction_summary]
      @total_amount_in = result[:total_amount_in]
      @total_amount_out = result[:total_amount_out]
      @pagy, transactions = pagy(result[:model])
      @transactions = transactions.decorate
    end
  end

  def excel
    run(::TransactionSummary::Operations::Excel, current_branch:) do |result|
      wb = result[:workbook]

      send_data wb.to_stream.read,
                type:        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                filename:    "tong_hop_giao_dich_#{Date.current.strftime('%d%m%Y')}.xlsx",
                disposition: "attachment"
    end
  end
end
