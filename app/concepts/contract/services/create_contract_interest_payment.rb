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
        # generate_weekly_percent_payments
      when InterestCalculationMethod.config[:code][:weekly_fixed]
        # generate_weekly_fixed_payments
      when InterestCalculationMethod.config[:code][:monthly_30]
        # generate_monthly_30_payments
      when InterestCalculationMethod.config[:code][:monthly_calendar]
        # generate_monthly_calendar_payments
      end
    end

    private

    attr_reader :contract, :processed_by
  end
end
