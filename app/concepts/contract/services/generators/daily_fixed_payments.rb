module Contract::Services::Generators
  class DailyFixedPayments < Base
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
      end_date = if withdrawal_principals.present?
        withdrawal_principals.last.transaction_date
      else
        contract.contract_end_date
      end

      current_from = start_date

      while current_from <= end_date
        current_to = current_from + (contract.interest_period_in_days - 1).days

        # Đảm bảo kỳ cuối không vượt quá ngày kết thúc hợp đồng
        current_to = [ current_to, end_date ].min

        # Tính số ngày thực tế của kỳ này
        actual_days = (current_to - current_from + 1).to_i

        # Tính lãi cho kỳ này
        interest_amount = contract.interest_rate * actual_days

        schedule << {
          contract_id: contract.id,
          from: current_from,
          to: current_to,
          number_of_days: actual_days,
          amount: interest_amount,
          total_amount: interest_amount,
          payment_status: contract.closed? ? "paid" : "unpaid",
          total_paid: contract.closed? ? interest_amount : 0
        }

        # Chuẩn bị cho kỳ tiếp theo
        current_from = current_to + 1.day

        # Tránh vòng lặp vô hạn
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
