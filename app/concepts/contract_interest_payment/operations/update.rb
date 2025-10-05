# frozen_string_literal: true

module ContractInterestPayment::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::ContractInterestPayment, :find)
      step Contract::Build(constant: ContractInterestPayment::Contracts::Update)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
    }
  end
end
