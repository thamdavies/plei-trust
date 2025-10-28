module Contract::Services::Generators
  class DailyPerMillionPayments < Base
    def call
      insert_data
    end

    def info
      insert_data(save: false)
    end

    private

    def insert_data(save: true)
      schedule = []

      end_date = contract.contract_end_date
      current_from = start_date
      # Bắt đầu với số tiền gốc ban đầu - sử dụng total_amount thay vì loan_amount
      accumulated_loan_amount = contract.loan_amount
      additional_loans_sorted = contract.additional_loans.order(:transaction_date).to_a

      while current_from <= end_date
        current_to = current_from + (contract.interest_period_in_days - 1).days
        current_to = [ current_to, end_date ].min

        # Lọc các khoản vay thêm CHỈ thuộc về kỳ này
        period_additional_loans = additional_loans_sorted.filter_map do |al|
          if al.transaction_date >= current_from && al.transaction_date <= current_to
            { date: al.transaction_date.to_fs(:date_vn), change: al.amount }
          else
            nil
          end
        end

        interest_amount, current_principal = calculate_interest(
          accumulated_loan_amount,
          contract.interest_rate * 1_000,
          current_from,
          current_to,
          period_additional_loans
        )

        accumulated_loan_amount = current_principal

        actual_days = (current_to - current_from + 1).to_i

        schedule << {
          contract_id: contract.id,
          from: current_from,
          to: current_to,
          number_of_days: actual_days,
          amount: interest_amount,
          total_amount: interest_amount
        }

        current_from = current_to + 1.day
        break if current_from > end_date
      end

      if save
        create_payments(schedule)
      else
        schedule
      end
    end
  end
end
