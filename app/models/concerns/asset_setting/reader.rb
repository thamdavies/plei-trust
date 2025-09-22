module AssetSetting::Reader
  extend ActiveSupport::Concern

  def interest_calculation_method_obj
    InterestCalculationMethod.find_by(code: self[:interest_calculation_method])
  end
end
