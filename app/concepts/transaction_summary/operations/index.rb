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
      contract_activities = current_branch.contract_activities.includes(:trackable, :owner).decorate
      ctx[:contract_activities] = contract_activities.map do |activity|
        contract = activity.trackable
        user = activity.owner
        OpenStruct.new(
          contract_type_name: contract.contract_type.name,
          contract_code: contract.code,
          asset_name: contract.asset_name,
          transaction_by: user.full_name,
          customer_name: contract.customer.full_name,
          transaction_date: activity.created_at.to_date.to_fs(:date_vn),
          description: I18n.t(activity.key),
          amount_in: activity.fm_debit_amount,
          amount_out: activity.fm_credit_amount,
          notes: activity.fm_note
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
      ctx[:transactions] = ctx[:contract_activities]
      ctx[:transaction_summary] = OpenStruct.new

      true
    end
  end
end
