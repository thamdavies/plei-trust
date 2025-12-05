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

      @loan_amount = contract.total_amount
      @months = contract.contract_term
      @annual_rate = contract.interest_rate.to_f
      monthly_rate = (@annual_rate / 100.0) / 12.0
      current_from = start_date

      # 1. TÍNH TIỀN GỐC CỐ ĐỊNH (Principal)
      # Chia đều tiền gốc cho các tháng. Làm tròn 4 số để lưu DB.
      # Trong ví dụ của bạn: 10.000.000 / 5 = 2.000.000
      base_principal = (@loan_amount.to_f / @months).round(4)

      schedule = []
      current_balance = @loan_amount.to_f
      total_interest = 0
      total_principal = 0

      (1..@months).each do |i|
        # --- TÍNH TOÁN NGÀY THÁNG ---
        period_start = i == 1 ? current_from : (current_from >> (i - 1))
        period_end = current_from >> i
        days_in_period = (period_end - period_start).to_i

        # --- TÍNH TOÁN TÀI CHÍNH ---

        # 1. Tính Lãi: Dựa trên dư nợ hiện tại
        interest = (current_balance * monthly_rate).round(4)

        # 2. Tính Gốc:
        # Nếu là tháng cuối cùng, gốc = toàn bộ dư nợ còn lại (để tránh sai số lẻ)
        # Nếu không, gốc = base_principal (cố định)
        if i == @months
          principal = current_balance
        else
          principal = base_principal
        end

        # 3. Tính Tổng tiền phải trả tháng này
        monthly_payment = (principal + interest).round(4)

        # Cập nhật dư nợ
        current_balance -= principal

        # Xử lý hiển thị số 0 tuyệt đối
        current_balance = 0 if current_balance.abs < 0.01

        total_interest += interest
        total_principal += principal

        schedule << {
          contract_id: contract.id,
          branch_id: contract.branch_id,
          from: period_start,
          to: period_end,
          number_of_days: days_in_period,
          amount: monthly_payment, # Tổng trả (Giảm dần)
          other_amount: interest,       # Lãi (Giảm dần)
          total_amount: monthly_payment,
          balance: current_balance
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
