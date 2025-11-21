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
end
