module Contract::Services
  class ContractInterestPaymentGenerator < ApplicationService
    def initialize(contract:, start_date: nil)
      @contract = contract
      @start_date = start_date
    end

    def call
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        InterestGenerators::DailyPerMillionPayments.new(contract:, start_date:).call
      when InterestCalculationMethod.config[:code][:daily_fixed]
        InterestGenerators::DailyFixedPayments.new(contract:, start_date:).call
      end
    end

    def info
      case @contract.interest_calculation_method
      when InterestCalculationMethod.config[:code][:daily_per_million]
        InterestGenerators::DailyPerMillionPayments.new(contract:, start_date:).info
      when InterestCalculationMethod.config[:code][:daily_fixed]
        InterestGenerators::DailyFixedPayments.new(contract:, start_date:).info
      end
    end

    private

    attr_reader :contract, :start_date
  end
end
