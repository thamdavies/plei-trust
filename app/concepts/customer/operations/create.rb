# frozen_string_literal: true

module Customer::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(Customer, :new)
      step Contract::Build(constant: Customer::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
