module Contract::Services::Generators
  class InstallmentPrincipalEqualPayments < Base
    def call
      insert_data
    end

    def info
      insert_data(save: false)
    end

    private

    def insert_data(save: true)
      schedule = []

      term = contract.contract_term
      rate = contract.interest_rate
      total_principal = contract.loan_amount
      current_date = start_date

      # Calculate fixed principal payment per month
      monthly_principal = (total_principal / term).round(0)

      remaining_principal = total_principal

      (1..term).each do |i|
        # Interest on remaining balance
        interest_amount = (remaining_principal * rate / 100.0).round(0)

        # Adjust principal for the last month to handle rounding differences
        current_principal = (i == term) ? remaining_principal : monthly_principal

        total_payment = interest_amount + current_principal

        from_date = current_date
        to_date = current_date + 1.month - 1.day

        schedule << {
          contract_id: contract.id,
          from: from_date,
          to: to_date,
          number_of_days: (to_date - from_date + 1).to_i,
          amount: interest_amount,
          # principal_amount: current_principal,
          total_amount: total_payment,
          payment_status: contract.closed? ? "paid" : "unpaid",
          total_paid: contract.closed? ? total_payment : 0
        }

        remaining_principal -= current_principal
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
