class ContractDecorator < ApplicationDecorator
  delegate_all

  decorates_association :contract_interest_payments
  decorates_association :customer
  decorates_association :reduce_principals
  decorates_association :additional_loans
  decorates_association :contract_extensions
  decorates_association :activities

  def customer_name
    customer.full_name
  end

  def fm_contract_date
    contract_date&.to_fs(:date_vn)
  end

  def fm_interest_rate
    "#{interest_rate}#{interest_calculation_method_obj&.percent_unit}"
  end

  def fm_contract_term
    return "#{contract_date.to_fs(:date_vn)} - #{contract_date.to_fs(:date_vn)}" if no_interest?

    record = interest_payments
    "#{record.first.from.to_fs(:date_vn)} - #{contract_end_date.to_fs(:date_vn)}"
  end

  def fm_total_interest
    ActionController::Base.helpers.number_with_delimiter(
      total_interest,
      delimiter: ".",
      separator: ",",
      precision: 0,
      strip_insignificant_zeros: true
    ) + " VNĐ"
  end

  def fm_paid_interest
    ActionController::Base.helpers.number_with_delimiter(
      total_paid_interest,
      delimiter: ".",
      separator: ",",
      precision: 0,
      strip_insignificant_zeros: true
    ) + " VNĐ"
  end

  def status_badge
    text, variant = state
    RubyUI::Badge(variant:) { text }
  end

  # Returns the formatted due date for the next interest payment
  #
  # @return [String] The due date formatted in Vietnamese date format, or empty string if no interest applies
  #
  # The method determines the due date based on the interest collection method:
  # - If interest is collected in advance, returns the 'from' date of the first unpaid payment
  # - If interest is collected in arrears, returns the 'to' date of the first unpaid payment
  # - Returns empty string if the contract has no interest
  def fm_due_date
    return "" if no_interest?

    schedule = unpaid_interest_payments.first.presence || contract_interest_payments.order(:from).last
    if collect_interest_in_advance
      schedule.from.to_fs(:date_vn)
    else
      schedule.to.to_fs(:date_vn)
    end
  end
end
