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

  def pawn_total_amount
    @pawn_total_amount ||= begin
      if pawn_total_display.nil?
        branch.pawn_total(date)
      else
        pawn_total_display
      end.to_i
    end
  end

  def fm_pawn_total
    pawn_total_amount.to_currency(unit: "")
  end

  def installment_total_amount
    @installment_total_amount ||= begin
      if installment_total_display.nil?
        branch.installment_total(date)
      else
        installment_total_display
      end.to_i
    end
  end

  def fm_installment_total
    installment_total_amount.to_currency(unit: "")
  end

  def credit_total_amount
    @credit_total_amount ||= begin
      if credit_total_display.nil?
        branch.credit_total(date)
      else
        credit_total_display
      end.to_i
    end
  end

  def fm_credit_total
    credit_total_amount.to_currency(unit: "")
  end

  def income_expense_total_amount
    @income_expense_total_amount ||= begin
      if income_expense_total_display.nil?
        branch.income_expense_total(date)
      else
        income_expense_total_display
      end.to_i
    end
  end

  def fm_income_expense_total
    income_expense_total_amount.to_currency(unit: "")
  end

  def capital_total_amount
    @capital_total_amount ||= begin
      if capital_total_display.nil?
        branch.capital_total(date)
      else
        capital_total_display
      end.to_i
    end
  end

  def fm_capital_total
    capital_total_amount.to_currency(unit: "")
  end
end
