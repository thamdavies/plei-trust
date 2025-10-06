class ContractInterestPaymentDecorator < ApplicationDecorator
  delegate_all

  def fm_dates
    "#{from.to_fs(:date_vn)} - #{to.to_fs(:date_vn)}"
  end
end
