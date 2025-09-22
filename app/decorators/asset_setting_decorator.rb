class AssetSettingDecorator < ApplicationDecorator
  delegate_all

  def fm_interest_rate
    "#{default_interest_rate}#{interest_calculation_method_obj&.percent_unit}"
  end

  def fm_interest_period
    "#{interest_period} #{interest_calculation_method_obj&.unit}"
  end

  def fm_contract_types
    contract_types.map(&:name).join(", ")
  end
end
