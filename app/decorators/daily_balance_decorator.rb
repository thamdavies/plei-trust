class DailyBalanceDecorator < ApplicationDecorator
  delegate_all

  def fm_date
    date.to_fs(:date_vn)
  end

  def fm_opening_balance
    opening_balance.to_currency(unit: "")
  end

  def fm_closing_balance
    closing_balance.to_currency(unit: "")
  end
end
