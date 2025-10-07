# frozen_string_literal: true

module CapitalContract::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(::Contract, :find)
      step Contract::Build(constant: CapitalContract::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
