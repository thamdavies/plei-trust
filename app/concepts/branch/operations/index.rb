# frozen_string_literal: true

module Branch::Operations
  class Index < ApplicationOperation
    step :model
    step :filter
    step :sort

    def model(ctx, params:, **)
      ctx[:model] = Branch.order(id: :desc)
    end

    def filter(ctx, params:, model:, **)
      ctx[:model] = model.ransack(params[:q]).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(id: :desc)
    end
  end
end
