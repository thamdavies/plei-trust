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
      withdrawal_principals = contract.withdrawal_principals
      is_withdrawal = withdrawal_principals.exists?

      end_date = if is_withdrawal
        withdrawal_principals.last.transaction_date
      else
        contract.contract_end_date
      end
      current_from = start_date
      # Bắt đầu với số tiền gốc ban đầu - sử dụng total_amount thay vì loan_amount
      accumulated_loan_amount = contract.loan_amount
      withdrawal_principals = contract.withdrawal_principals

      if withdrawal_principals.blank?
        additional_loans = contract.additional_loans
        reduce_principals = contract.reduce_principals
      else
        additional_loans = []
        reduce_principals = []
      end

      while current_from <= end_date
        current_to = current_from + (contract.interest_period_in_days - 1).days
        current_to = [ current_to, end_date ].min

        # Lọc các khoản vay thêm CHỈ thuộc về kỳ này
        period_additional_loans = additional_loans.filter_map do |al|
          if al.transaction_date >= current_from && al.transaction_date <= current_to
            { date: al.transaction_date.to_fs(:date_vn), change: al.amount, fee: 0 }
          else
            nil
          end
        end

        period_reduce_principals = reduce_principals.filter_map do |pp|
          if pp.transaction_date >= current_from && pp.transaction_date <= current_to
            { date: pp.transaction_date.to_fs(:date_vn), change: -pp.amount, fee: pp.amount * Contract.config[:principal_payment_fee_percent] }
          else
            nil
          end
        end

        interest_amount, current_principal = calculate_interest(
          accumulated_loan_amount,
          contract.interest_rate * 1_000,
          current_from,
          current_to,
          period_additional_loans + period_reduce_principals
        )

        accumulated_loan_amount = current_principal

        actual_days = (current_to - current_from + 1).to_i

        schedule << {
          contract_id: contract.id,
          from: current_from,
          to: current_to,
          number_of_days: actual_days,
          payment_status: is_withdrawal ? "paid" : "unpaid",
          amount: interest_amount,
          total_amount: interest_amount,
          total_paid: is_withdrawal ? interest_amount : 0
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

    def calculate_interest(initial_principal, interest_rate_per_million_per_day, start_date, end_date, transactions)
      # Chuyển đổi tỷ lệ lãi suất (VD: 10k/1tr/ngày) thành tỷ lệ %/ngày
      # 10,000 / 1,000,000 = 0.01 (1%)
      daily_interest_rate_decimal = interest_rate_per_million_per_day.to_f / 1_000_000.0

      current_principal = initial_principal
      current_date = start_date
      total_interest = 0

      # Sắp xếp các giao dịch theo ngày để xử lý tuần tự
      sorted_transactions = transactions.sort_by { |t| t[:date].parse_date_vn }

      # Thêm một "giao dịch" cuối cùng là ngày kết thúc kỳ để đảm bảo tính hết lãi
      last_transaction_date = end_date + 1 # Ngày sau ngày kết thúc kỳ
      sorted_transactions << { date: last_transaction_date.to_fs(:date_vn), change: 0, fee: 0 }

      # Lặp qua các giao dịch để tính lãi cho từng giai đoạn
      sorted_transactions.each do |transaction|
        transaction_date = transaction[:date].parse_date_vn

        # Số ngày tính lãi cho giai đoạn này
        # Lãi được tính đến HẾT ngày trước khi giao dịch (transaction_date) xảy ra
        # hoặc đến HẾT ngày end_date
        if transaction_date >= current_date
          days_in_period = (transaction_date - current_date).to_i

          # Tính lãi cho giai đoạn (Gốc hiện tại * Tỷ lệ lãi * Số ngày)
          interest_in_period = current_principal * daily_interest_rate_decimal * days_in_period
          interest_in_period += (transaction[:fee] || 0)
          total_interest += interest_in_period

          # Di chuyển đến ngày giao dịch
          current_date = transaction_date
        end

        # Cập nhật tiền gốc sau giao dịch (chỉ khi chưa đạt đến ngày kết thúc kỳ)
        if transaction_date <= end_date
          current_principal += transaction[:change]
        end
      end

      [ total_interest, current_principal ]
    end

    def calculate_subtraction_interest(initial_principal, interest_rate_per_million_per_day, start_date, end_date, transactions)
      # Chuyển đổi tỷ lệ lãi suất (VD: 10k/1tr/ngày) thành tỷ lệ %/ngày
      # 10,000 / 1,000,000 = 0.01 (1%)
      daily_interest_rate_decimal = interest_rate_per_million_per_day.to_f / 1_000_000.0

      current_principal = initial_principal
      current_date = start_date
      total_interest = 0

      # Sắp xếp các giao dịch theo ngày để xử lý tuần tự
      sorted_transactions = transactions.sort_by { |t| t[:date].parse_date_vn }

      # Thêm một "giao dịch" cuối cùng là ngày kết thúc kỳ để đảm bảo tính hết lãi
      last_transaction_date = end_date + 1 # Ngày sau ngày kết thúc kỳ
      sorted_transactions << { date: last_transaction_date.to_fs(:date_vn), change: 0 }

      # Lặp qua các giao dịch để tính lãi cho từng giai đoạn
      sorted_transactions.each do |transaction|
        transaction_date = transaction[:date].parse_date_vn

        # Số ngày tính lãi cho giai đoạn này
        # Lãi được tính đến HẾT ngày trước khi giao dịch (transaction_date) xảy ra
        # hoặc đến HẾT ngày end_date
        if transaction_date > current_date
          days_in_period = (transaction_date - current_date).to_i

          # Tính lãi cho giai đoạn (Gốc hiện tại * Tỷ lệ lãi * Số ngày)
          interest_in_period = current_principal * daily_interest_rate_decimal * days_in_period
          fee = transaction[:change] * Contract.config[:principal_payment_fee_percent]
          total_interest += (interest_in_period + fee)

          # Di chuyển đến ngày giao dịch
          current_date = transaction_date
        end

        # Cập nhật tiền gốc sau giao dịch (chỉ khi chưa đạt đến ngày kết thúc kỳ)
        if transaction_date <= end_date
          current_principal -= transaction[:change]
        end
      end

      [ total_interest, current_principal ]
    end
  end
end
