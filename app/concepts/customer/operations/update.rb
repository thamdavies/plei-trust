# frozen_string_literal: true

module Customer::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(Customer, :find)
      step Contract::Build(constant: Customer::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
