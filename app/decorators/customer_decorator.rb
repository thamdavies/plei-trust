class CustomerDecorator < ApplicationDecorator
  delegate_all

  def fm_old_debt_amount(unit: true, abs: false)
    if abs
      old_debt_amount.abs
    else
      old_debt_amount
    end.to_f.to_currency(unit: unit ? "VNĐ" : "")
  end

  def fm_old_debt_amount_with_label(unit: true)
    if old_debt_amount.positive?
      "Tiền thừa KH: <span class='text-green-600 dark:text-green-400'>#{fm_old_debt_amount(unit:)}</span>".html_safe
    else
      "Nợ cũ KH: <span class='text-red-600 dark:text-red-400'>#{fm_old_debt_amount(unit:, abs: true)}</span>".html_safe
    end
  end
end
