# frozen_string_literal: true

module AssetSetting::Operations
  class Index < ApplicationOperation
    step :model
    step :filter
    step :sort

    def model(ctx, params:, **)
      ctx[:model] = AssetSetting.includes(:contract_types)
    end

    def filter(ctx, params:, model:, **)
      ctx[:model] = model.ransack(params[:q]).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(id: :desc)
    end
  end
end
