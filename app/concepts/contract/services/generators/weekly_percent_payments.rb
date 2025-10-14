module Contract::Services::Generators
  class WeeklyPercentPayments < Base
    def call
      insert_data
    end

    def info
      insert_data(save: false)
    end

    private

    def insert_data(save: true)
      payment_data = []
      start_date = contract.contract_date
      contract_term = contract.contract_term * 7
      end_date = start_date + contract_term - 1
      interest_period_in_days = contract.interest_period * 7
      loan_amount = contract.loan_amount

      payment_cycle = (contract_term / interest_period_in_days.to_f).ceil
      current_date = start_date

      1.upto(payment_cycle) do
        payment_start_date = current_date
        payment_end_date = [ current_date + interest_period_in_days - 1, end_date ].min
        number_of_days = (payment_end_date - payment_start_date).to_i + 1
        amount = loan_amount * (contract.interest_rate / 100.0) * (number_of_days / 7.0)
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

      if save
        create_payments(payment_data)
      else
        payment_data
      end
    end
  end
end
