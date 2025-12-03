module Branch::Reader
  def opening_balance(date = Date.current)
    daily_balances.find_by(date: date)&.opening_balance || 0
  end

  def current_cash_balance(date = Date.current)
    # 1. Lấy tiền đầu ngày
    opening = opening_balance(date)

    # 2. Tính biến động trong ngày (Income - Expense)
    # Sử dụng bảng financial_transactions có sẵn của bạn
    transactions = financial_transactions.where(transaction_date: date)

    # Gom nhóm theo loại (Thu/Chi) dựa vào transaction_type.is_income
    income = transactions.select { |t| t.transaction_type.is_income? }.sum(&:amount)
    expense = transactions.select { |t| !t.transaction_type.is_income? }.sum(&:amount)

    (opening + income - expense) * 1_000
  end
end
