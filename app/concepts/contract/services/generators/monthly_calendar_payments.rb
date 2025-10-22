module Contract::Services::Generators
  class MonthlyCalendarPayments < Base
    def call
      insert_data
    end

    def info
      insert_data(save: false)
    end

    private

    # def insert_data(save: true)
    #   payment_data = []
    #   start_date = contract.contract_date
    #   total_periods = contract.contract_term  # Total number of monthly periods
    #   interest_period = contract.interest_period  # Months per payment cycle
    #   current_date = start_date

    #   1.upto(payment_cycle) do |cycle|
    #     payment_start_date = current_date

    #     # Calculate end date by adding calendar months
    #     remaining_periods = [ interest_period, total_periods - ((cycle - 1) * interest_period) ].min
    #     payment_end_date = current_date + (remaining_periods.months)

    #     # Calculate the number of days in the payment period for informational purposes only.
    #     # This does NOT affect the fixed monthly payment amount.
    #     number_of_days = (payment_end_date - payment_start_date).to_i + 1

    #     amount = contract.loan_amount * (contract.interest_rate / 100.0)
    #     total_amount = amount

    #     payment_data << build_payment_attrs(
    #       from: payment_start_date,
    #       to: payment_end_date,
    #       amount: amount,
    #       number_of_days: number_of_days,
    #       total_amount: total_amount
    #     )

    #     current_date = payment_end_date
    #   end

    #   if save
    #     create_payments(payment_data)
    #   else
    #     payment_data
    #   end
    # end

    def insert_data(save: true)
      schedule = []

      end_date = contract.contract_end_date
      current_from = start_date

      schedule_index = 1

      while current_from <= end_date
        months_to_add = contract.interest_period
        current_from = schedule_index > 1 ? current_from - 1.day : current_from
        current_to = calculate_period_end_date(current_from, months_to_add, contract.contract_date.day)

        # Đảm bảo kỳ cuối không vượt quá ngày kết thúc hợp đồng
        current_to = [ current_to, end_date ].min

        # Tính số ngày thực tế của kỳ này
        actual_days = (current_to - current_from + 1).to_i

        num_of_days = months_between(current_from, current_to) * 30

        # Tính lãi cho kỳ này
        interest_amount = contract.interest_in_days(days_count: num_of_days)

        schedule << {
          contract_id: contract.id,
          from: current_from,
          to: current_to,
          number_of_days: actual_days,
          amount: interest_amount,
          total_amount: interest_amount
        }

        # Chuẩn bị cho kỳ tiếp theo
        current_from = current_to + 1.day
        schedule_index += 1

        # Tránh vòng lặp vô hạn
        break if current_from > end_date
      end

      if save
        create_payments(schedule)
      else
        schedule
      end
    end

    def calculate_period_end_date(start_date, months_to_add, target_day)
      # Tính tháng và năm đích
      target_month = start_date.month + months_to_add
      target_year = start_date.year

      # Xử lý trường hợp vượt qua năm
      while target_month > 12
        target_month -= 12
        target_year += 1
      end

      # Xử lý trường hợp ngày đích không tồn tại trong tháng đích (ví dụ: 31/2)
      last_day_of_target_month = Date.new(target_year, target_month, -1).day
      actual_day = [ target_day, last_day_of_target_month ].min

      Date.new(target_year, target_month, actual_day)
    end

    def months_between(start_date, end_date)
      ((end_date.year - start_date.year) * 12) + (end_date.month - start_date.month)
    end
  end
end
