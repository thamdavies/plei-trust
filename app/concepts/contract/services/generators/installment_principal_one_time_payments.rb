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

      @loan_amount = contract.total_amount
      @months = contract.contract_term
      @annual_rate = contract.interest_rate.to_f
      monthly_rate = (@annual_rate / 100.0) / 12.0
      current_from = start_date

      current_balance = @loan_amount.to_f
      total_interest = 0
      total_principal = 0

      (1..@months).each do |i|
        # --- TÍNH TOÁN NGÀY THÁNG ---
        period_start = i == 1 ? current_from : (current_from >> (i - 1))
        period_end = current_from >> i
        days_in_period = (period_end - period_start).to_i

        # --- TÍNH TOÁN TÀI CHÍNH ---

        # 1. Tính Lãi:
        # Vì gốc không đổi nên lãi tháng nào cũng giống nhau (trừ sai số làm tròn nếu có)
        interest = (current_balance * monthly_rate).round(4)

        # 2. Tính Gốc:
        # - Nếu chưa đến tháng cuối: Gốc trả = 0
        # - Nếu là tháng cuối: Gốc trả = Toàn bộ số dư nợ
        if i == @months
          principal = current_balance
        else
          principal = 0
        end

        # 3. Tính Tổng tiền trả tháng này
        monthly_payment = (principal + interest).round(4)

        # Cập nhật dư nợ
        current_balance -= principal

        # Fix số 0 tuyệt đối
        current_balance = 0 if current_balance.abs < 0.01

        total_interest += interest
        total_principal += principal

        schedule << {
          contract_id: contract.id,
          branch_id: contract.branch_id,
          from: period_start,
          to: period_end,
          number_of_days: days_in_period,
          other_amount: interest,  # Số tiền lãi trong kỳ
          amount: monthly_payment, # Số tiền trả hàng tháng
          total_amount: monthly_payment,
          balance: current_balance,
          payment_status: contract.closed? ? "paid" : "unpaid",
          total_paid: contract.closed? ? monthly_payment : 0
        }
      end

      if save
        create_payments(schedule)
      else
        schedule
      end
    end
  end
end
