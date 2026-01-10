module Branch::Writer
  extend ActiveSupport::Concern

  def update_opening_balance_for_date(date: Date.current)
    ActiveRecord::Base.transaction do
      previous_date = date - 1.day
      previous_daily_balance = daily_balances.find_by(date: previous_date)
      previous_cash_balance = current_cash_balance(previous_date)

      if previous_daily_balance.blank?
        message = "Previous daily balance for branch #{id} on #{previous_date} not found."
        Rails.logger.error(message)
        return
      end

      previous_daily_balance.update!(closing_balance: previous_cash_balance)
      daily_balance_record = daily_balances.find_or_initialize_by(date: date)
      if daily_balance_record.new_record?
        daily_balance_record.opening_balance = previous_cash_balance
        daily_balance_record.closing_balance = 0
        daily_balance_record.save!
      end

      branch = previous_daily_balance.branch
      msg = ">>>> Cập nhập tiền đầu ngày ngày #{date} cho chi nhánh #{branch.name}"
      Rails.logger.info(msg)
    end
  end

  def cancel_transaction(financial_transaction)
    financial_transactions.create!(
      transaction_date: Date.current,
      transaction_type_code: financial_transaction.transaction_type_code,
      amount: financial_transaction.amount_display * -1,
      created_by: financial_transaction.created_by,
      owner: financial_transaction.owner,
      recordable_type_code: financial_transaction.recordable_type_code,
      canceled_at: Time.current,
      description: "Hủy giao dịch ID #{financial_transaction.id}"
    )
    financial_transaction.update!(canceled_at: Time.current)
  end

  class_methods do
    def update_opening_balance_for_all_branches(date: Date.current)
      Branch.find_each do |branch|
        branch.update_opening_balance_for_date(date: date)
      end
    end

    def seed_daily_balances_for_all_branches(end_date: Date.current)
      Branch.find_each do |branch|
        start_date = branch.daily_balances.minimum(:date) || branch.created_at.to_date
        (start_date..end_date).each do |date|
          branch.update_opening_balance_for_date(date: date)
        end
      end
    end
  end
end
