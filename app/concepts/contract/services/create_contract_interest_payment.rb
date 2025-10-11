module Contract::Services
  class CreateContractInterestPayment < ApplicationService
    def initialize(contract:)
      @contract = contract
    end

    def call
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        Generators::DailyPerMillionPayments.new(contract:).call
      when InterestCalculationMethod.config[:code][:daily_fixed]
        Generators::DailyFixedPayments.new(contract:).call
      when InterestCalculationMethod.config[:code][:weekly_percent]
        Generators::WeeklyPercentPayments.new(contract:).call
      when InterestCalculationMethod.config[:code][:weekly_fixed]
        Generators::WeeklyFixedPayments.new(contract:).call
      when InterestCalculationMethod.config[:code][:monthly_30]
        Generators::Monthly30Payments.new(contract:).call
      when InterestCalculationMethod.config[:code][:monthly_calendar]
        Generators::MonthlyCalendarPayments.new(contract:).call
      end
    end

    def info
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        Generators::DailyPerMillionPayments.new(contract:).info
      when InterestCalculationMethod.config[:code][:daily_fixed]
        Generators::DailyFixedPayments.new(contract:).info
      when InterestCalculationMethod.config[:code][:weekly_percent]
        Generators::WeeklyPercentPayments.new(contract:).info
      when InterestCalculationMethod.config[:code][:weekly_fixed]
        Generators::WeeklyFixedPayments.new(contract:).info
      when InterestCalculationMethod.config[:code][:monthly_30]
        Generators::Monthly30Payments.new(contract:).info
      when InterestCalculationMethod.config[:code][:monthly_calendar]
        Generators::MonthlyCalendarPayments.new(contract:).info
      end
    end

    private

    attr_reader :contract, :processed_by
  end
end
