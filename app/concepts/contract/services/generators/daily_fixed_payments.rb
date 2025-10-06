module Contract::Services::Generators
  class DailyFixedPayments < Base
    def initialize(contract:, processed_by:)
      @contract = contract
      @processed_by = processed_by
    end

    def call
      insert_data
    end

    private

    attr_reader :contract, :processed_by

    def insert_data
      payment_data = []
      start_date = contract.contract_date
      contract_term = contract.contract_term
      end_date = start_date + contract_term - 1
      interest_period = contract.interest_period
      payment_cycle = (contract_term / interest_period.to_f).ceil
      current_date = start_date

      1.upto(payment_cycle) do
        payment_start_date = current_date
        payment_end_date = [ current_date + interest_period - 1, end_date ].min
        number_of_days = (payment_end_date - payment_start_date).to_i + 1
        amount = contract.interest_rate * number_of_days
        total_amount = amount

        payment_data << build_payment_attrs(
          from: payment_start_date,
          to: payment_end_date,
          amount: amount,
          number_of_days: number_of_days,
          total_amount: total_amount
        )

        current_date = payment_end_date + 1
      end

      create_payments(payment_data)
    end
  end
end
