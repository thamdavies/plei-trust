class DailyBalanceDecorator < ApplicationDecorator
  delegate_all

  def fm_date
    date.to_fs(:date_vn)
  end

  def fm_opening_balance
    opening_balance_amount.to_currency(unit: "")
  end

  def fm_closing_balance
    closing_balance_amount.to_currency(unit: "")
  end

  def fm_pawn_total
    pawn_total_amount.to_currency(unit: "")
  end

  def fm_installment_total
    installment_total_amount.to_currency(unit: "")
  end

  def fm_credit_total
    credit_total_amount.to_currency(unit: "")
  end

  def fm_income_expense_total
    income_expense_total_amount.to_currency(unit: "")
  end

  def fm_capital_total
    capital_total_amount.to_currency(unit: "")
  end

  def fm_active_pawn_total
    active_pawn_total_amount.to_currency(unit: "")
  end

  def fm_active_credit_total
    active_credit_total_amount.to_currency(unit: "")
  end

  def fm_active_installment_total
    active_installment_total_amount.to_currency(unit: "")
  end

  def fm_capital_payable_total
    capital_payable_total_amount.to_currency(unit: "")
  end

  def fm_asset_total
    asset_total_amount.to_currency(unit: "")
  end
end
