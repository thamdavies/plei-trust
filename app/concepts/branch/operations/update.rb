# frozen_string_literal: true

module Branch::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(Branch, :find)
      step Contract::Build(constant: Branch::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
