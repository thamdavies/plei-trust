# frozen_string_literal: true

module InstallmentContract::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::Contract, :new)
      step Contract::Build(constant: InstallmentContract::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
      step :create_contract_interest_payments
      step :create_activity_log
    }

    private

    def create_contract_interest_payments(ctx, model:, **)
      return unless model.can_edit_contract?

      service = ::Contract::Services::ContractInterestPaymentGenerator.new(contract: model)
      service.call
      true
    end

    def create_activity_log(ctx, model:, current_user:, **)
      debit_amount = 0
      credit_amount = model.loan_amount
      parameters = {
        debit_amount:,
        credit_amount:
      }

      parameters = model.reverse_debit_amount_params(parameters)
      model.create_activity! key: "activity.contract.create", owner: current_user, parameters: parameters
      true
    end
  end
end
