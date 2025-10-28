module Contract::Services::Generators
  class Base
    attr_reader :interest_per_day

    # Initialize with contract
    # @param contract [Contract] The contract for which interest payments are being generated
    # @return [void]
    def initialize(contract:, start_date: nil)
      @contract = contract
      @start_date = start_date || contract.contract_date
    end

    private

    attr_reader :contract, :start_date

    def payment_cycle
      (contract.contract_term / contract.interest_period.to_f).ceil
    end

    def build_payment_attrs(from:, to:, amount:, number_of_days:, total_amount:)
      {
        contract_id: contract.id,
        from:,
        to:,
        amount:,
        number_of_days:,
        total_amount:,
        total_paid: 0,
        other_amount: 0
      }
    end

    def create_payments(payment_data)
      return [] if payment_data.empty?

      reset_prev_payments
      reset_toward_payments

      ContractInterestPayment.insert_all!(payment_data)
    end

    def reset_prev_payments
      remove_payments = ContractInterestPayment.where(contract_id: contract.id, custom_payment: false, payment_status: :unpaid)

      if start_date.present?
        remove_payments = remove_payments.where("#{ContractInterestPayment.table_name}.from <= ?", contract.contract_date)
      end

      remove_payments.delete_all if remove_payments.exists?
    end

    # Ensure idempotency by removing existing payments for this contract
    def reset_toward_payments
      remove_payments = ContractInterestPayment.where(contract_id: contract.id, custom_payment: false, payment_status: :unpaid)

      if start_date.present?
        remove_payments = remove_payments.where("#{ContractInterestPayment.table_name}.from >= ?", start_date)
      end

      remove_payments.delete_all if remove_payments.exists?
    end

    # Hàm tính tổng tiền lãi cho một kỳ dựa trên các giao dịch thay đổi tiền gốc
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

    # For debugging purposes
    def print_data
      contract.contract_interest_payments.each do |data|
        puts "From: #{data.from}, To: #{data.to}, Amount: #{data.amount_formatted}, Days: #{data.number_of_days}, Total: #{data.total_amount}"
        puts "-----------------------------------"
      end
    end
  end
end
