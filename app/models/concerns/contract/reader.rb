module Contract::Reader
  extend ActiveSupport::Concern

  def no_interest?
    interest_calculation_method == InterestCalculationMethod.config[:code][:investment_capital]
  end

  def can_edit_contract?
    contract_interest_payments.paid.count.zero?
  end

  def interest_calculation_method_obj
    InterestCalculationMethod.find_by(code: interest_calculation_method)
  end

  def total_interest
    (contract_interest_payments.sum(:total_amount) * 1_000).to_i
  end

  def total_paid_interest
    (contract_interest_payments.paid.sum(:total_amount) * 1_000).to_i
  end

  def first_interest_payment
    @first_interest_payment ||= contract_interest_payments.order(:from).first
  end

  def last_unpaid_interest_payment
    @last_unpaid_interest_payment ||= contract_interest_payments.order(:to).unpaid.last
  end

  def nearest_unpaid_interest_payment
    @nearest_unpaid_interest_payment ||= contract_interest_payments.unpaid.order(:from).first
  end

  def nearest_paid_interest_payment
    @nearest_paid_interest_payment ||= contract_interest_payments.paid.order(:from).last
  end

  def nearest_due_date
    nearest_unpaid_interest_payment.to.to_fs(:date_vn)
  end

  # Loại vốn
  def capital_type
    return contract_type.name if interest_rate.blank? || interest_rate.zero?

    "Đi vay"
  end

  def state
    return unless contract_type

    contract_code = contract_type.code
    inner_text, color = if closed?
      [ I18n.t("contract_state.#{contract_code}.closed_contract"), :green ]
    elsif no_interest?
      [ "Đang đầu tư", :green ]
    elsif collect_interest_in_advance && first_interest_payment.unpaid? && first_interest_payment.to > Date.current
      [ I18n.t("contract_state.#{contract_code}.due_date"), :yellow ]
    elsif last_unpaid_interest_payment && last_unpaid_interest_payment.to < Date.current
      [ I18n.t("contract_state.#{contract_code}.overdue"), :red ]
    elsif contract_interest_payments.due_date_less_than(Date.current).present?
      [ I18n.t("contract_state.#{contract_code}.interest_late"), :rose ]
    elsif nearest_due_date && nearest_due_date == Date.current
      [ I18n.t("contract_state.#{contract_code}.pay_today"), :yellow ]
    else
      [ I18n.t("contract_state.#{contract_code}.on_time"), :green ]
    end

    [ inner_text, color ]
  end
end
