module Contract::Services
  class CreateContractInterestPayment < ApplicationService
    def initialize(contract:, processed_by:)
      @contract     = contract
      @processed_by = processed_by
    end

    def call
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        Contract::Services::Generators::DailyPerMillionPayments.new(contract:, processed_by:).call
      when InterestCalculationMethod.config[:code][:daily_fixed]
        Contract::Services::Generators::DailyFixedPayments.new(contract:, processed_by:).call
      when InterestCalculationMethod.config[:code][:weekly_percent]
        Contract::Services::Generators::WeeklyPercentPayments.new(contract:, processed_by:).call
      when InterestCalculationMethod.config[:code][:weekly_fixed]
        Contract::Services::Generators::WeeklyFixedPayments.new(contract:, processed_by:).call
      when InterestCalculationMethod.config[:code][:monthly_30]
        Contract::Services::Generators::Monthly30Payments.new(contract:, processed_by:).call
      when InterestCalculationMethod.config[:code][:monthly_calendar]
        Contract::Services::Generators::MonthlyCalendarPayments.new(contract:, processed_by:).call
      end
    end

    private

    attr_reader :contract, :processed_by
  end
end
