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
      branch = model.branch
      branch.financial_transactions.create!(
        transaction_date: Date.current,
        transaction_type_code: TransactionType::INCOME_CONTRACT_CHANGE,
        recordable_type_code: model.contract_type_code,
        amount: model.loan_amount * 1_000,
        created_by: branch.users.first,
        owner: model
      )

      true
    end
  end
end
