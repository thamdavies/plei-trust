class ContractDecorator < ApplicationDecorator
  delegate_all

  decorates_association :contract_interest_payments

  def customer_name
    customer.full_name
  end

  def fm_contract_date
    contract_date&.to_fs(:date_vn)
  end

  def contract_type_name
    return contract_type&.name if interest_rate.blank? || interest_rate.zero?

    "Đi vay"
  end

  def fm_interest_rate
    "#{interest_rate}#{interest_calculation_method_obj&.percent_unit}"
  end

  def contract_status_badge
    case status
    when "active"
      RubyUI::Badge(variant: :success) { "Đang đầu tư" }
    when "closed"
      RubyUI::Badge(variant: :secondary) { "Đã đóng" }
    end
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
