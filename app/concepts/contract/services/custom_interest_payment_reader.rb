module Contract::Services
  class CustomInterestPaymentReader < ApplicationService
    def initialize(contract:, from_date:, to_date:, old_debt_amount: 0, other_amount: 0)
      @contract = contract
      @from_date = from_date
      @to_date = to_date
      @old_debt_amount = old_debt_amount
      @other_amount = other_amount
    end

    def call
      fetch_custom_interest_payment
    end

    private

    attr_reader :contract, :from_date, :to_date, :old_debt_amount, :other_amount

    def fetch_custom_interest_payment
      number_of_days = (to_date - from_date).to_i + 1
      total_amount = contract.interest_in_days(days_count: number_of_days) * 1_000
      total_interest_amount = total_amount + other_amount + old_debt_amount

      unless contract.no_interest?
        contract.contract_date = to_date
        payment_data = ContractInterestPaymentGenerator.new(contract:).info
        next_interest_date = contract.collect_interest_in_advance ? payment_data.first[:from] : payment_data.first[:to]
      end

      {
        from_date: from_date.to_fs(:date_vn),
        to_date: to_date.to_fs(:date_vn),
        next_interest_date: next_interest_date&.to_fs(:date_vn),
        days_count: number_of_days,
        old_debt_amount: old_debt_amount.to_currency,
        interest_amount: total_amount.to_currency,
        interest_amount_raw: total_amount,
        other_amount: other_amount.to_currency(unit: "").strip,
        total_interest_amount: total_interest_amount.to_currency,
        total_amount: (total_interest_amount + contract.total_amount * 1_000).to_currency,
        total_amount_raw: total_interest_amount + contract.total_amount * 1_000,
        customer_payment_amount: total_interest_amount.to_currency(unit: "").strip
      }
    end
  end
end
