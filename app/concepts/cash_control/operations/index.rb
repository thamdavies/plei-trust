module CashControl::Operations
  class Index < ApplicationOperation
    step :load_summary_data
    step :load_transactions

    def load_summary_data(ctx, current_branch:, **)
      ctx[:summary] = OpenStruct.new(
        opening_balance: current_branch.opening_balance,
        current_cash_balance: current_branch.current_cash_balance,
        capital_amount: current_branch.invest_amount_formatted
      )

      true
    end

    def load_transactions(ctx, current_branch:, **)
      ctx[:transactions] = current_branch.financial_transactions.includes(:transaction_type, :created_by).order(id: :desc)

      true
    end
  end
end
