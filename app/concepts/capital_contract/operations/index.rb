module CapitalContract::Operations
  class Index < ApplicationOperation
    step :format_created_date
    step :filter
    step :sort

    def filter(ctx, params:, current_branch:, **)
      filter_view = params.dig(:q, :status_eq).presence || "active_contracts"
      ctx[:model] = current_branch.send(filter_view).joins(:contract_type).capital_contracts.ransack(ctx[:params][:q]).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(contract_date: :desc)
    end
  end
end
