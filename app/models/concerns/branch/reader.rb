module Branch::Reader
  # Hàm tính Quỹ tiền mặt hiển thị (Real-time)
  def current_cash_balance(date = Date.current)
    opening = opening_balance(date)

    # Công thức: Vốn + Đầu ngày + (Thu - Chi)
    default_capital = contracts.capital_contracts.find_by(is_default_capital: true)
    default_capital.total_amount.to_f * 1_000 + opening + today_net_transaction(date)
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
    @reminders_count ||= begin
      # Lấy danh sách contract_id có reminder mới nhất là cancel_scheduled_reminder
      cancelled_contract_ids = ContractReminder
        .from("(
          SELECT DISTINCT ON (contract_id) *
          FROM contract_reminders
          ORDER BY contract_id, created_at DESC
        ) AS contract_reminders")
        .where(reminder_type: "cancel_scheduled_reminder")
        .pluck(:contract_id)

      # Đếm số contract không nằm trong danh sách bị hủy
      contracts.without_capital.where.not(id: cancelled_contract_ids).count
    end
  end
end
