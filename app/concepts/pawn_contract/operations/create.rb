# frozen_string_literal: true

module PawnContract::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::Contract, :new)
      step Contract::Build(constant: PawnContract::Contracts::Create)
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
      return true if model.field_cannot_edit?

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
      model.create_activity!(
        key: "activity.contract.create",
        branch_id: model.branch_id,
        owner: current_user,
        parameters: parameters
      )

      true
    end

    def create_financial_transaction(ctx, model:, **)
      model.create_financial_transaction!(is_income: false, description: I18n.t("activity.contract.create"))

      true
    end
  end
end
