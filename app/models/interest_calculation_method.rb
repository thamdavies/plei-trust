class InterestCalculationMethod < ActiveHash::Base
  self.data = YAML.load_file(Rails.root.join("db", "fixtures", "interest_calculation_methods.yml"))["interest_calculation_methods"].select { |item| item["is_active"] }

  class_attribute :config, default: {
    code: {
      daily_per_million: "daily_per_million",
      daily_fixed: "daily_fixed",
      weekly_percent: "weekly_percent",
      weekly_fixed: "weekly_fixed",
      monthly_30: "monthly_30",
      monthly_calendar: "monthly_calendar",
      investment_capital: "investment_capital",
      installment_principal_one_time: "installment_principal_one_time",
      installment_principal_equal: "installment_principal_equal",
      installment_principal_interest_equal: "installment_principal_interest_equal"
    }
  }
end
