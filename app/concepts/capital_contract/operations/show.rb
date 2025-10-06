module CapitalContract::Operations
  class Show < ApplicationOperation
    step Model(::Contract, :find)
  end
end
