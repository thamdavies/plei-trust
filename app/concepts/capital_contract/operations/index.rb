module CapitalContract::Operations
  class Index < ApplicationOperation
    step :model
    step :format_created_date
    step :filter
    step :sort

    def model(ctx, params:, **)
      ctx[:model] = ::Contract.joins(:contract_type).capital_contracts
    end

    def filter(ctx, params:, current_branch:, model:, **)
      filter_view = params.dig(:q, :status_eq).presence || "active_contracts"
      ctx[:model] = current_branch.send(filter_view).ransack(ctx[:params][:q]).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(contract_date: :desc)
    end
  end
end
