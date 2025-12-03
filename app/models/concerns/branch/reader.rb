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
end
