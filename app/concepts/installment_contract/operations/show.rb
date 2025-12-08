module InstallmentContract::Operations
  class Show < ApplicationOperation
    step Model(::Contract, :find)
  end
end
