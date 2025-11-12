module Contract::Writer
  extend ActiveSupport::Concern

  def recalculate_contract_date
    if InterestCalculationMethod.config[:code][:monthly_calendar] != interest_calculation_method
      self.contract_date = contract_date.next_day
    end
  end

  def reset_interest_payments!
    contract_interest_payments.delete_all
    Contract::Services::ContractInterestPaymentGenerator.new(contract: self).call
  end

  def reverse_debit_amount_params(parameters)
    debit_amount = parameters[:debit_amount]
    credit_amount = parameters[:credit_amount]

    if pawn?
      parameters[:credit_amount] = debit_amount
      parameters[:debit_amount] = credit_amount
    end

    parameters
  end
end
