# frozen_string_literal: true

module CapitalContract::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::Contract, :new)
      step Contract::Build(constant: CapitalContract::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
      step :create_contract_interest_payments
      step :create_activity_log
      step :create_financial_transaction
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

    def create_financial_transaction(ctx, model:, **)
      model.create_financial_transaction!(is_income: true)

      true
    end
  end
end
