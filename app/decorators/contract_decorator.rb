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

    "Cho vay"
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

  # ngày phải đóng lãi
  # nếu đóng lãi trước thì = ngày ký hợp đồng
  # nếu đóng lãi sau thì = ngày ký hợp đồng + kỳ hạn đóng lãi
  # đối với hợp đồng vốn thì không có kỳ hạn đóng lãi nên sẽ để trống
  def fm_due_date
    return "" if interest_calculation_method == "capital_investment"

    if collect_interest_in_advance
      contract_date&.to_fs(:date_vn)
    else
      ""
    end
  end

  def interest_calculation_method_obj
    InterestCalculationMethod.find_by(code: interest_calculation_method)
  end
end
