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
      # step :create_contract_interest_payments
    }

    def create_contract_interest_payments(ctx, form:, **)
      service = Contract::Services::CreateContractInterestPayment.new(
        contract: form.model,
        processed_by: form.model.created_by
      )
      service.call
      true
    end
  end
end
