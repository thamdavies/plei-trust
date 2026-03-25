module TransactionSummary::Operations
  class Index < ApplicationOperation
    step :format_date_params
    step :load_transactions

    def format_date_params(ctx, params:, **)
      format_date_params!(params, [
        [ :q, :transaction_date_gteq ],
        [ :q, :transaction_date_lteq ]
      ])
      ctx[:params] = params

      true
    end

    def load_transactions(ctx, params:, current_branch:, **)
      scope = ViewTransactionSummary
        .where(branch_id: current_branch.id)
        .ransack(params[:q]).result

      totals = scope.pick(
        Arel.sql("SUM(raw_debit_amount) * 1000"),
        Arel.sql("SUM(raw_credit_amount) * 1000")
      )

      ctx[:total_amount_in] = totals[0].to_d
      ctx[:total_amount_out] = totals[1].to_d
      ctx[:model] = scope.order(created_at: :desc)

      true
    end
  end
end
