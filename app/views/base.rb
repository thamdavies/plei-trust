# frozen_string_literal: true

class Views::Base < Components::Base
  # Lấy CSRF token thông qua view helpers
  def form_authenticity_token
    view_context.form_authenticity_token
  end

  def form_method
    form.model.new_record? ? :post : :patch
  end

  def contract_type_label(type: nil)
    type ||= contract_type
    case type
    when :capital
      OpenStruct.new(
        loan_amount: "Số tiền đầu tư",
        contract_date: "Ngày góp vốn"
      )
    when :pawn
      OpenStruct.new(
        loan_amount: "Số tiền cầm",
        contract_date: "Ngày vay"
      )
    else
      OpenStruct.new(
        loan_amount: "Số tiền vay",
        contract_date: "Ngày vay"
      )
    end
  end

  def contract_labels(withdraw_principal)
    I18n.t("labels.contract.#{contract.contract_type_code}.#{withdraw_principal}")
  end
end
