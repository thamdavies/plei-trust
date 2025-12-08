module Branch::Writer
  extend ActiveSupport::Concern

  def update_opening_balance_for_date(date: Date.current)
    previous_date = date - 1.day
    previous_daily_balance = daily_balances.find_by(date: previous_date)
    previous_cash_balance = current_cash_balance(previous_date)

    # if previous_daily_balance.blank?
    #   message = "Previous daily balance for branch #{id} on #{previous_date} not found."
    #   Rails.logger.error(message)
    #   return
    # end

    SlackAlarm.perform(
      description: ":male-technologist: Cập nhập tiền đầu ngày #{date}",
      cmd: "Branch.update_opening_balance_for_date",
      context: "Announcement from the *DNM Bot*",
    ) do
      previous_daily_balance.update!(closing_balance: previous_cash_balance / 1000.to_f)
      daily_balance_record = daily_balances.find_or_initialize_by(date: date)
      if daily_balance_record.new_record?
        daily_balance_record.opening_balance = previous_cash_balance
        daily_balance_record.closing_balance = 0
        daily_balance_record.save!
      end
    end
  end

  class_methods do
    def update_opening_balance_for_all_branches
      Branch.find_each do |branch|
        branch.update_opening_balance_for_date(date: Date.current)
      end
    end
  end
end
