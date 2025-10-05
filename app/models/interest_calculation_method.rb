class InterestCalculationMethod < ActiveHash::Base
  class_attribute :config, default: {
    code: {
      daily_per_million: "daily_per_million",
      daily_fixed: "daily_fixed",
      weekly_percent: "weekly_percent",
      weekly_fixed: "weekly_fixed",
      monthly_30: "monthly_30",
      monthly_calendar: "monthly_calendar",
      investment_capital: "investment_capital"
    }
  }
  self.data = YAML.load_file(Rails.root.join("db", "fixtures", "interest_calculation_methods.yml"))["interest_calculation_methods"]
end
