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
    }
  end
end
