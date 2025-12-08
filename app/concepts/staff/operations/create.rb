# frozen_string_literal: true

module Staff::Operations
  class Create < ApplicationOperation
    # Only used to setup the form.
    class Present < ApplicationOperation
      step Model(User, :new)
      step Contract::Build(constant: Staff::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
