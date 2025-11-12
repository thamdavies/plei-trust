module PawnContract::Operations
  class Show < ApplicationOperation
    step Model(::Contract, :find)
  end
end
