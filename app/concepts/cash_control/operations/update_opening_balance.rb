module CashControl::Operations
  class UpdateOpeningBalance < ApplicationOperation
    class Present < ApplicationOperation
      step Model(FinancialTransaction, :new)
      step Contract::Build(constant: CashControl::Contracts::UpdateOpeningBalance)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step Contract::Persist()
    }
  end
end
