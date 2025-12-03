module Branch::Reader
  # Hàm tính Quỹ tiền mặt hiển thị (Real-time)
  def current_cash_balance(date = Date.current)
    opening = opening_balance(date)

    # Công thức: Vốn + Đầu ngày + (Thu - Chi)
    invest_amount.to_f * 1_000 + opening + today_net_transaction(date)
  end

  # Hàm tính biến động dòng tiền trong ngày (Thu - Chi)
  def today_net_transaction(date = Date.current)
    transactions = financial_transactions.where(transaction_date: date)

    income = transactions.select { |t| t.transaction_type.is_income? }.sum(&:amount).to_f * 1_000
    expense = transactions.select { |t| !t.transaction_type.is_income? }.sum(&:amount).to_f * 1_000

    income - expense
  end

  def opening_balance(date = Date.current)
    daily_balances.find_by(date: date)&.opening_balance.to_f * 1_000
  end
end
