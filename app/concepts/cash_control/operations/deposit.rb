module CashControl::Operations
  class Deposit < ApplicationOperation
    class Present < ApplicationOperation
      step Model(FinancialTransaction, :new)
      step Contract::Build(constant: CashControl::Contracts::Deposit)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
    }
  end
end
