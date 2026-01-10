class DailyBalanceDecorator < ApplicationDecorator
  delegate_all

  def fm_date
    date.to_fs(:date_vn)
  end

  def opening_balance_amount
    @opening_balance_amount ||= begin
      if opening_balance_display.nil?
        branch.opening_balance(date)
      else
        opening_balance_display
      end.to_i
    end
  end

  def fm_opening_balance
    opening_balance_amount.to_currency(unit: "")
  end

  def closing_balance_amount
    @closing_balance_amount ||= begin
      if closing_balance_display.nil?
        opening_balance_amount + pawn_total_amount + credit_total_amount + installment_total_amount + income_expense_total_amount + capital_total_amount
      else
        closing_balance_display
      end.to_i
    end
  end

  def fm_closing_balance
    closing_balance_amount.to_currency(unit: "")
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

  # Đang cho vay + Khách nợ
  def active_pawn_total_amount
    @active_pawn_total_amount ||= begin
      if active_pawn_total_display.nil?
        branch.contracts.pawn_contracts.active.by_date(date).sum(:loan_amount).to_f * 1_000
      else
        active_pawn_total_display
      end.to_i
    end
  end

  def fm_active_pawn_total
    active_pawn_total_amount.to_currency(unit: "")
  end

  def active_credit_total_amount
    @active_credit_total_amount ||= begin
      if active_credit_total_display.nil?
        branch.contracts.credit_contracts.active.by_date(date).sum(:loan_amount).to_f * 1_000
      else
        active_credit_total_display
      end.to_i
    end
  end

  def fm_active_credit_total
    active_credit_total_amount.to_currency(unit: "")
  end

  def active_installment_total_amount
    @active_installment_total_amount ||= begin
      if active_installment_total_display.nil?
        branch.contracts.installment_contracts.active.by_date(date).sum(:loan_amount).to_f * 1_000
      else
        active_installment_total_display
      end.to_i
    end
  end

  def fm_active_installment_total
    active_installment_total_amount.to_currency(unit: "")
  end

  def capital_payable_total_amount
    @capital_payable_total_amount ||= begin
      if capital_payable_total_display.nil?
        branch.contracts.capital_contracts.by_date(date).sum(:loan_amount).to_f * 1_000
      else
        capital_payable_total_display
      end.to_i
    end
  end

  def fm_capital_payable_total
    capital_payable_total_amount.to_currency(unit: "")
  end

  def asset_total_amount
    @asset_total_amount ||= begin
      if asset_total_display.nil?
        closing_balance_amount + active_pawn_total_amount + active_credit_total_amount + active_installment_total_amount - capital_payable_total_amount
      else
        asset_total_display
      end.to_i
    end
  end

  def fm_asset_total
    asset_total_amount.to_currency(unit: "")
  end
end
