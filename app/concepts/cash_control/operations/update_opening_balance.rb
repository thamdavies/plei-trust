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
      step :create_activity_log
    }

    def save(ctx, model:, current_user:, daily_balance:, **)
      daily_balance.update(opening_balance: model.amount, created_by: current_user)
    end

    def create_activity_log(ctx, model:, current_user:, current_branch:, **)
      parameters = {
        amount: model.amount / 1000.to_f
      }
      current_branch.create_activity! key: Settings.activity_keys.cash_control.update_opening_balance, owner: current_user, parameters: parameters
    end
  end
end
