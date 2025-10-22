class FinancialTransactionDecorator < ApplicationDecorator
  delegate_all

  def fm_transaction_date
    object.transaction_date.to_fs(:date_vn)
  end
end
