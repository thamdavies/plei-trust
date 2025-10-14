module Contract::Writer
  extend ActiveSupport::Concern

  def recalculate_contract_date
    if InterestCalculationMethod.config[:code][:monthly_calendar] != interest_calculation_method
      self.contract_date = contract_date.next_day
    end
  end

  def reset_interest_payments!
    contract_interest_payments.delete_all
    Contract::Services::CreateContractInterestPayment.new(contract: self).call
  end
end
