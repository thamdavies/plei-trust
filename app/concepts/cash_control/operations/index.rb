module CashControl::Operations
  class Index < ApplicationOperation
    step :load_summary_data
    step :load_transactions

    def load_summary_data(ctx, current_branch:, **)
      ctx[:summary] = OpenStruct.new(
        opening_balance: current_branch.opening_balance.to_currency(unit: ""),
        current_cash_balance: current_branch.current_cash_balance.to_currency(unit: ""),
        capital_amount: current_branch.invest_amount_formatted
      )

      true
    end

    def load_transactions(ctx, current_branch:, **)
      keys = [
        Settings.activity_keys.cash_control.deposit,
        Settings.activity_keys.cash_control.update_opening_balance
      ]
      ctx[:transactions] = current_branch.activities.includes(:owner).where(key: keys)

      true
    end
  end
end
