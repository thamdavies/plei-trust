# frozen_string_literal: true

module Branch::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(Branch, :new)
      step Contract::Build(constant: Branch::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
