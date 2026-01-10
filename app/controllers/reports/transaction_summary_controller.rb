class Reports::TransactionSummaryController < ApplicationController
  def index
    run(TransactionSummary::Operations::Index, current_branch:) do |result|
      @transactions = result[:transactions]
    end
  end
end
