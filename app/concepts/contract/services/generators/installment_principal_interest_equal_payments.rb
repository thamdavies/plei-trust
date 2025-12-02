module Contract::Services::Generators
  class InstallmentPrincipalInterestEqualPayments < Base
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
      current_from = start_date

      monthly_rate = (@annual_rate / 100.0) / 12.0

      # Tính PMT (Số tiền trả đều hàng tháng)
      factor = (1 + monthly_rate)**@months
      monthly_payment = (@loan_amount * (monthly_rate * factor) / (factor - 1)).round(3)

      schedule = []
      current_balance = @loan_amount
      total_interest = 0
      total_principal = 0

      (1..@months).each do |i|
        # --- TÍNH TOÁN NGÀY THÁNG ---
        period_start = i == 1 ? current_from : (current_from >> (i - 1))
        period_end = current_from >> i

        # Tính số ngày thực tế trong kỳ (End Date - Start Date)
        days_in_period = (period_end - period_start).to_i

        # --- TÍNH TOÁN TÀI CHÍNH ---
        # Lưu ý: Theo logic ảnh cũ của bạn, lãi được tính theo THÁNG ĐỊNH KỲ (30 ngày/tháng hoặc 1/12 năm)
        # chứ không phụ thuộc vào số ngày thực tế (28, 30 hay 31).
        # Nếu muốn tính lãi theo ngày thực tế (Bank style), công thức sẽ khác.
        # Ở đây tôi giữ nguyên công thức cũ để khớp số liệu ảnh bạn gửi.
        interest = (current_balance * monthly_rate)
        principal = monthly_payment - interest

        # Xử lý tháng cuối cùng
        if i == @months
          # Logic giữ nguyên để đảm bảo số tiền trả hàng tháng cố định
          principal = current_balance
          monthly_payment = principal + interest
        end

        current_balance -= principal
        current_balance = 0 if current_balance < 0 && current_balance > -100

        total_interest += interest
        total_principal += principal

        schedule << {
          contract_id: contract.id,
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
