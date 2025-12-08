module Contract::Services::Generators
  class WeeklyPercentPayments < Base
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

      while current_from <= end_date
        current_to = current_from + (contract.interest_period_in_days - 1).days

        # Đảm bảo kỳ cuối không vượt quá ngày kết thúc hợp đồng
        current_to = [ current_to, end_date ].min

        # Tính số ngày thực tế của kỳ này
        actual_days = (current_to - current_from + 1).to_i

        # Tính lãi cho kỳ này
        interest_amount = contract.interest_in_days(days_count: actual_days)

        schedule << {
          contract_id: contract.id,
          branch_id: contract.branch_id,
          from: current_from,
          to: current_to,
          number_of_days: actual_days,
          amount: interest_amount,
          total_amount: interest_amount
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
