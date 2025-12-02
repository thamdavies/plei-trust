module Contract::Services::Generators
  class InstallmentPrincipalOneTimePayments < Base
    def call
      insert_data
    end

    def info
      insert_data(save: false)
    end

    private

    def insert_data(save: true)
      schedule = []

      term = contract.contract_term # Assumed in months
      rate = contract.interest_rate # Assumed % per month
      principal = contract.loan_amount
      current_date = start_date

      (1..term).each do |i|
        # Interest is calculated on the full principal
        interest_amount = (principal * rate / 100.0).round(0)

        # Principal is paid only in the last period
        current_principal = (i == term) ? principal : 0

        from_date = current_date
        to_date = current_date + 1.month - 1.day

        schedule << {
          contract_id: contract.id,
          from: from_date,
          to: to_date,
          number_of_days: (to_date - from_date + 1).to_i,
          amount: interest_amount,
          # principal_amount: current_principal,
          total_amount: interest_amount + current_principal,
          payment_status: contract.closed? ? "paid" : "unpaid",
          total_paid: contract.closed? ? (interest_amount + current_principal) : 0
        }

        current_date = current_date + 1.month
      end

      if save
        create_payments(schedule)
      else
        schedule
      end
    end
  end
end
