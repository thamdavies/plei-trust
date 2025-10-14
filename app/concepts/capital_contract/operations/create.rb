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
    }

    private

    def create_contract_interest_payments(ctx, model:, **)
      return unless model.can_edit_contract?

      service = ::Contract::Services::CreateContractInterestPayment.new(contract: model)
      service.call
      true
    end
  end
end
