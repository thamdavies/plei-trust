module TransactionSummary::Operations
  class Index < ApplicationOperation
    AmountChange = Struct.new(:amount_in, :amount_out, :difference)

    step :format_date_params
    step :init_transaction_summary
    step :load_opening_balance
    step :load_transaction_details
    step :load_pawn_amount
    step :load_installment_amount
    step :load_income_amount
    step :load_expense_amount
    step :load_capital_amount
    step :load_remaining_cash

    def format_date_params(ctx, params:, **)
      format_date_params!(params, [
        [ :q, :transaction_date_gteq ],
        [ :q, :transaction_date_lteq ]
      ])
      ctx[:params] = params

      if params.dig(:q, :transaction_date_gteq).blank? && params.dig(:q, :transaction_date_lteq).blank?
        params[:q] = {} if params[:q].nil?
        params[:q][:transaction_date_gteq] = Date.current.to_s
        params[:q][:transaction_date_lteq] = Date.current.to_s
      end

      true
    end

    def init_transaction_summary(ctx, current_branch:, **)
      ctx[:transaction_summary] = OpenStruct.new(
        opening_balance: 0,
        pawn: AmountChange.new(0, 0),
        installment: AmountChange.new(0, 0),
        income: AmountChange.new(0, 0),
        expense: AmountChange.new(0, 0),
        capital: AmountChange.new(0, 0),
        remaining_cash: 0,
      )

      true
    end

    def load_opening_balance(ctx, current_branch:, **)
      daily_balances = current_branch.daily_balances.ransack(
        date_gteq: ctx[:params].dig(:q, :transaction_date_gteq),
        date_lteq: ctx[:params].dig(:q, :transaction_date_lteq)
      ).result
      ctx[:transaction_summary].opening_balance = (daily_balances.order(:date).first&.opening_balance || 0) * 1_000

      true
    end

    def load_transaction_details(ctx, params:, current_branch:, **)
      scope = ViewTransactionSummary
        .where(branch_id: current_branch.id)
        .ransack(params[:q]).result

      totals = scope.pick(
        Arel.sql("SUM(amount_in) * 1000"),
        Arel.sql("SUM(amount_out) * 1000")
      )

      ctx[:total_amount_in] = totals[0].to_d
      ctx[:total_amount_out] = totals[1].to_d
      ctx[:model] = scope.order(created_at: :desc)

      true
    end

    def load_pawn_amount(ctx, current_branch:, **)
      ctx[:transaction_summary].pawn.amount_in = ctx[:model].select { |record| record.pawn? }.sum(&:amount_in) * 1_000
      ctx[:transaction_summary].pawn.amount_out = ctx[:model].select { |record| record.pawn? }.sum(&:amount_out) * 1_000
      ctx[:transaction_summary].pawn.difference = ctx[:transaction_summary].pawn.amount_in + ctx[:transaction_summary].pawn.amount_out

      true
    end

    def load_installment_amount(ctx, current_branch:, **)
      ctx[:transaction_summary].installment.amount_in = ctx[:model].select { |record| record.installment? }.sum(&:amount_in) * 1_000
      ctx[:transaction_summary].installment.amount_out = ctx[:model].select { |record| record.installment? }.sum(&:amount_out) * 1_000
      ctx[:transaction_summary].installment.difference = ctx[:transaction_summary].installment.amount_in + ctx[:transaction_summary].installment.amount_out
       true
    end

    def load_income_amount(ctx, current_branch:, **)
      ctx[:transaction_summary].income.amount_in = ctx[:model].select { |record| record.income? }.sum(&:amount_in) * 1_000
      ctx[:transaction_summary].income.amount_out = ctx[:model].select { |record| record.income? }.sum(&:amount_out) * 1_000
      ctx[:transaction_summary].income.difference = ctx[:transaction_summary].income.amount_in + ctx[:transaction_summary].income.amount_out

       true
    end

    def load_expense_amount(ctx, current_branch:, **)
      ctx[:transaction_summary].expense.amount_in = ctx[:model].select { |record| record.expense? }.sum(&:amount_in) * 1_000
      ctx[:transaction_summary].expense.amount_out = ctx[:model].select { |record| record.expense? }.sum(&:amount_out) * 1_000
      ctx[:transaction_summary].expense.difference = ctx[:transaction_summary].expense.amount_in + ctx[:transaction_summary].expense.amount_out

       true
    end

    def load_capital_amount(ctx, current_branch:, **)
      ctx[:transaction_summary].capital.amount_in = ctx[:model].select { |record| record.capital? }.sum(&:amount_in) * 1_000
      ctx[:transaction_summary].capital.amount_out = ctx[:model].select { |record| record.capital? }.sum(&:amount_out) * 1_000
      ctx[:transaction_summary].capital.difference = ctx[:transaction_summary].capital.amount_in + ctx[:transaction_summary].capital.amount_out

       true
    end

    def load_remaining_cash(ctx, **)
      ctx[:transaction_summary].remaining_cash =
        (ctx[:transaction_summary].opening_balance +
        ctx[:transaction_summary].pawn.difference +
        ctx[:transaction_summary].installment.difference +
        ctx[:transaction_summary].income.difference +
        ctx[:transaction_summary].expense.difference +
        ctx[:transaction_summary].capital.difference).presence || 0

      true
    end
  end
end
