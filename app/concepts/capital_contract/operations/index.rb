module CapitalContract::Operations
  class Index < ApplicationOperation
    step :model
    step :format_created_date
    step :filter
    step :sort

    def model(ctx, params:, **)
      ctx[:model] = ::Contract.joins(:contract_type).capital_contracts
    end

    def filter(ctx, params:, model:, **)
      ctx[:model] = model.ransack(ctx[:params][:q]).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(id: :desc)
    end
  end
end
