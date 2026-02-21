module TransactionSummary::Operations
  class Index < ApplicationOperation
    step :format_date_params
    step :load_contract_activities
    step :load_transactions
    step :set_result

    def format_date_params(ctx, params:, **)
      format_date_params!(params, [
        [ :q, :transaction_date_gteq ],
        [ :q, :transaction_date_lteq ]
      ])
      ctx[:params] = params

      true
    end

    def load_contract_activities(ctx, params:, current_branch:, **)
      contract_activities = current_branch.contract_activities
      ctx[:contract_activities] = contract_activities.map do |activity|
        OpenStruct.new(
          contract_type_name: activity.contract_type_name,
          contract_code: activity.contract_code,
          asset_name: activity.asset_name,
          transaction_by: activity.transaction_by,
          customer_name: activity.customer_name,
          transaction_date: activity.transaction_date,
          description: activity.description,
          amount_in: activity.amount_in,
          amount_out: activity.amount_out,
          notes: activity.notes
        )
      end

      true
    end

    def load_transactions(ctx, params:, current_branch:, **)
      ctx[:transactions] = current_branch.financial_transactions
        .ransack(params[:q]).result
        .includes(:transaction_type, :created_by)
        .order(id: :desc)

      true
    end

    def set_result(ctx, params:, **)
      ctx[:transactions] = []
      ctx[:transaction_summary] = OpenStruct.new

      true
    end
  end
end
