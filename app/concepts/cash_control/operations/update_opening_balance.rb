module CashControl::Operations
  class UpdateOpeningBalance < ApplicationOperation
    class Form
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :daily_balance, :amount
    end
    class Present < ApplicationOperation
      step Model(Form, :new)
      step Contract::Build(constant: CashControl::Contracts::UpdateOpeningBalance)
      step :set_defaults

      def set_defaults(ctx, model:, params:, **)
        model.assign_attributes(params)
        model.amount = "0" if model.amount.nil?
        model.amount = model.amount.remove_dots.to_f
        ctx[:daily_balance] = model.daily_balance
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
    }

    def save(ctx, model:, current_user:, daily_balance:, **)
      daily_balance.update(opening_balance: model.amount, created_by: current_user)
    end
  end
end
