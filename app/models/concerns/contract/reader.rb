module Contract::Reader
  extend ActiveSupport::Concern

  def no_interest?
    interest_calculation_method == InterestCalculationMethod.config[:code][:investment_capital]
  end

  def can_edit_contract?
    contract_interest_payments.paid.count.zero?
  end

  def interest_calculation_method_obj
    InterestCalculationMethod.find_by(code: interest_calculation_method)
  end
end
