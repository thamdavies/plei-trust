class FinancialTransactionDecorator < ApplicationDecorator
  delegate_all

  def fm_transaction_date
    object.transaction_date.to_fs(:date_vn)
  end

  def fm_cash_control_action_type
    case object.transaction_type.code
    when TransactionType::CASH_FUND_IMPORT
      "Nhập quỹ tiền mặt"
    when TransactionType::OPENING_BALANCE
      "Tiền đầu ngày"
    else
      "Hoạt động khác"
    end
  end
end
