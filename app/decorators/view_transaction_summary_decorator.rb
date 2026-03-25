class ViewTransactionSummaryDecorator < ApplicationDecorator
  delegate_all

  def fm_transaction_date
    transaction_date.to_fs(:date_vn)
  end

  def fm_amount_in
    (amount_in.to_d * 1_000).to_currency(unit: "")
  end

  def fm_amount_out
    (amount_out.to_d * 1_000).to_currency(unit: "")
  end

  def transactable_type_name
    return I18n.t("transactable_type.#{transactable_type_code}") if transactable_type_code.present?

    "-"
  end
end
