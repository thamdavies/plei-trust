module Contract::Services
  class ContractInterestPaymentGenerator < ApplicationService
    def initialize(contract:, start_date: nil)
      @contract = contract
      @start_date = start_date
    end

    def call
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        Generators::DailyPerMillionPayments.new(contract:, start_date:).call
      when InterestCalculationMethod.config[:code][:daily_fixed]
        Generators::DailyFixedPayments.new(contract:, start_date:).call
      when InterestCalculationMethod.config[:code][:weekly_percent]
        Generators::WeeklyPercentPayments.new(contract:, start_date:).call
      when InterestCalculationMethod.config[:code][:weekly_fixed]
        Generators::WeeklyFixedPayments.new(contract:, start_date:).call
      when InterestCalculationMethod.config[:code][:monthly_30]
        Generators::Monthly30Payments.new(contract:, start_date:).call
      when InterestCalculationMethod.config[:code][:monthly_calendar]
        Generators::MonthlyCalendarPayments.new(contract:, start_date:).call
      end
    end

    def info
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        Generators::DailyPerMillionPayments.new(contract:, start_date:).info
      when InterestCalculationMethod.config[:code][:daily_fixed]
        Generators::DailyFixedPayments.new(contract:, start_date:).info
      when InterestCalculationMethod.config[:code][:weekly_percent]
        Generators::WeeklyPercentPayments.new(contract:, start_date:).info
      when InterestCalculationMethod.config[:code][:weekly_fixed]
        Generators::WeeklyFixedPayments.new(contract:, start_date:).info
      when InterestCalculationMethod.config[:code][:monthly_30]
        Generators::Monthly30Payments.new(contract:, start_date:).info
      when InterestCalculationMethod.config[:code][:monthly_calendar]
        Generators::MonthlyCalendarPayments.new(contract:, start_date:).info
      end
    end

    private

    attr_reader :contract, :start_date
  end
end
