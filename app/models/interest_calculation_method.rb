class InterestCalculationMethod < ActiveHash::Base
  self.data = Settings.interest_calculation_methods.to_a
end
