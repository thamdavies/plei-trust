module Contract::Services::Generators
  class MonthlyCalendarPayments < Base
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
      total_periods = contract.contract_term  # Total number of monthly periods
      interest_period = contract.interest_period  # Months per payment cycle
      payment_cycle = (total_periods / interest_period.to_f).ceil
      current_date = start_date

      1.upto(payment_cycle) do |cycle|
        payment_start_date = current_date

        # Calculate end date by adding calendar months
        remaining_periods = [ interest_period, total_periods - ((cycle - 1) * interest_period) ].min
        payment_end_date = current_date + (remaining_periods.months)

        # Calculate the number of days in the payment period for informational purposes only.
        # This does NOT affect the fixed monthly payment amount.
        number_of_days = (payment_end_date - payment_start_date).to_i + 1

        amount = contract.loan_amount * (contract.interest_rate / 100.0)
        total_amount = amount

        payment_data << build_payment_attrs(
          from: payment_start_date,
          to: payment_end_date,
          amount: amount,
          number_of_days: number_of_days,
          total_amount: total_amount
        )

        current_date = payment_end_date
      end

      if save
        create_payments(payment_data)
      else
        payment_data
      end
    end
  end
end
