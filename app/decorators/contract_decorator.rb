class ContractDecorator < ApplicationDecorator
  delegate_all

  def customer_name
    customer.full_name
  end

  def fm_contract_date
    contract_date&.to_fs(:date_vn)
  end

  def contract_type_name
    contract_type&.name
  end

  def fm_interest_rate
    "#{interest_rate}#{interest_calculation_method_obj&.percent_unit}"
  end

  def interest_calculation_method_obj
    InterestCalculationMethod.find_by(code: interest_calculation_method)
  end
end
