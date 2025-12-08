class ContractInterestPaymentDecorator < ApplicationDecorator
  delegate_all

  def fm_dates
    "#{from.to_fs(:date_vn)} - #{to.to_fs(:date_vn)}"
  end

  def fm_paid_at
    paid_at.present? ? paid_at.to_date.to_fs(:date_vn) : "Chưa đóng"
  end

  def total_amount_currency
    "#{total_amount_formatted} VNĐ"
  end

  def installment_principal_amount
    (amount - other_amount) * 1_000
  end

  def fm_installment_principal_amount
    installment_principal_amount.to_currency(unit: "")
  end

  def installment_balance_amount
    (contract.total_amount - amount) * 1_000
  end

  def fm_installment_balance_amount
    installment_balance_amount.to_currency(unit: "")
  end
end
