module Dashboard::Operations
  class Index < ApplicationOperation
    step :fetch_active_contract_count
    step :fetch_active_loan_amount
    step :fetch_monthly_interest_collected
    step :build_response

    private

    def fetch_active_contract_count(ctx, current_branch:, **)
      ctx[:active_contract_count] = current_branch.contracts.without_capital.active.count

      true
    end

    def fetch_active_loan_amount(ctx, current_branch:, **)
      ctx[:active_loan_amount] = current_branch.contracts.without_capital.active.map(&:total_amount).sum * 1_000
      true
    end

    def fetch_monthly_interest_collected(ctx, current_branch:, **)
      ctx[:monthly_interest_collected] = current_branch.income_transactions
        .where(transaction_date: Date.current.beginning_of_month..Date.current.end_of_month)
        .sum(:amount)
      true
    end

    def build_response(ctx, current_branch:, **)
      ctx[:dashboard_data] = OpenStruct.new(
        cash_balance: current_branch.current_cash_balance.to_currency(unit: ""),
        active_contract_count: ctx[:active_contract_count],
        active_loan_amount: ctx[:active_loan_amount].to_currency(unit: ""),
        monthly_interest_collected: ctx[:monthly_interest_collected].to_currency(unit: "")
      )

      true
    end
  end
end
