module DailyCashFlow::Operations
  class DailyCashFlowForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :date_gteq
    attribute :date_lteq
  end

  class Index < ApplicationOperation
    step Model(DailyCashFlowForm, :new)
    step :assign_attributes
    step Contract::Build(constant: DailyCashFlow::Contracts::Index)
    step Contract::Validate()
    step :save

    def assign_attributes(ctx, model:, params:, **)
      values = params[:q] || params
      model.assign_attributes(values || {})

      true
    end

    def save(ctx, model:, current_branch:, **)
      params = {
        q: {
          date_gteq: model.date_gteq&.parse_date_vn,
          date_lteq: model.date_lteq&.parse_date_vn
        }
      }

      ctx[:daily_flows] = current_branch.daily_balances.order(:id).ransack(params[:q]).result.decorate

      true
    end
  end
end
