module Branch::Reader
  extend ActiveSupport::Concern

  # Hàm tính Quỹ tiền mặt hiển thị (Real-time)
  def current_cash_balance(date = Date.current)
    opening = opening_balance(date)

    # Công thức: Vốn + Đầu ngày + (Thu - Chi)
    default_capital = contracts.capital_contracts.today.sum(:loan_amount)
    default_capital.to_f * 1_000 + opening + today_net_transaction(date)
  end

  # Hàm tính biến động dòng tiền trong ngày (Thu - Chi)
  def today_net_transaction(date = Date.current)
    income = income_transactions.where(transaction_date: date).sum(:amount).to_f * 1_000
    expense = expense_transactions.where(transaction_date: date).sum(:amount).to_f * 1_000

    income - expense
  end

  def opening_balance(date = Date.current)
    daily_balances.find_by(date: date)&.opening_balance.to_f * 1_000
  end

  def reminders_count
    @reminders_count ||= reminders.count
  end

  def reminders
    latest_reminders = ContractReminder
      .select("DISTINCT ON (contract_id) *")
      .order("contract_id, created_at DESC")

    ContractReminder
      .from("(#{latest_reminders.to_sql}) AS contract_reminders")   # <– alias về tên gốc!
      .select("contract_reminders.*")
      .where("contract_reminders.reminder_type = ?", ContractReminder.reminder_types[:schedule_reminder])
  end
end
