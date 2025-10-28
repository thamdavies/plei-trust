module Contract::Reader
  extend ActiveSupport::Concern

  def no_interest?
    interest_calculation_method == InterestCalculationMethod.config[:code][:investment_capital]
  end

  def total_amount
    loan_amount - (principal_payments.sum(:amount)) + (additional_loans.sum(:amount))
  end

  def total_amount_formatted
    value = (total_amount * 1_000).to_i

    ActionController::Base.helpers.number_with_delimiter(
      value,
      delimiter: ".",
      separator: ",",
      precision: 0,
      strip_insignificant_zeros: true
    )
  end

  def total_amount_currency
    total_amount_formatted + " VNĐ"
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
    (contract_interest_payments.paid.sum(:total_paid) * 1_000).to_i
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
    (nearest_unpaid_interest_payment || nearest_paid_interest_payment).to.to_fs(:date_vn)
  end

  def interest_in_days(amount: nil, days_count: 0)
    return 0 if days_count.zero? || no_interest?

    amount ||= loan_amount

    case interest_calculation_method
    when InterestCalculationMethod.config[:code][:daily_per_million]
      interest_per_day = (amount / 1_000_000.0) * interest_rate * 1_000
      interest_per_day * days_count
    when InterestCalculationMethod.config[:code][:daily_fixed]
      days_count * interest_rate
    when InterestCalculationMethod.config[:code][:weekly_percent]
      num_of_weeks = (days_count / 7.0).ceil
      interest_per_week = amount * (interest_rate / 100.0)
      num_of_weeks * interest_per_week
    when InterestCalculationMethod.config[:code][:weekly_fixed]
      num_of_weeks = (days_count / 7.0).ceil
      num_of_weeks * interest_rate
    when InterestCalculationMethod.config[:code][:monthly_30], InterestCalculationMethod.config[:code][:monthly_calendar]
      ((amount * (interest_rate / 100.0)) / 30) * days_count
    else
      Rails.logger.warn("Unknown interest calculation method: #{interest_calculation_method}")
      0
    end.to_f.round(3)
  end

  def contract_term_in_days
    case interest_calculation_method
    when InterestCalculationMethod.config[:code][:daily_per_million], InterestCalculationMethod.config[:code][:daily_fixed]
      contract_term
    when InterestCalculationMethod.config[:code][:weekly_percent], InterestCalculationMethod.config[:code][:weekly_fixed]
      contract_term * 7
    when InterestCalculationMethod.config[:code][:monthly_30], InterestCalculationMethod.config[:code][:monthly_calendar]
      contract_term * 30
    end
  end

  def interest_period_in_days
    case interest_calculation_method
    when InterestCalculationMethod.config[:code][:daily_per_million], InterestCalculationMethod.config[:code][:daily_fixed]
      interest_period
    when InterestCalculationMethod.config[:code][:weekly_percent], InterestCalculationMethod.config[:code][:weekly_fixed]
      interest_period * 7
    when InterestCalculationMethod.config[:code][:monthly_30], InterestCalculationMethod.config[:code][:monthly_calendar]
      interest_period * 30
    end
  end

  def contract_end_date
    if interest_calculation_method == InterestCalculationMethod.config[:code][:monthly_calendar]
      # Nếu contract date là ngày 17 thì kỳ kết thúc hợp đồng sẽ là ngày 17 của tháng kết thúc
      return calculate_period_end_date(contract_date, contract_term, contract_date.day)
    end

    contract_date + contract_term_in_days.days - 1.day
  end

  def calculate_period_end_date(start_date, months_to_add, contract_day)
    tentative_end_date = start_date.advance(months: months_to_add)
    last_day_of_month = tentative_end_date.end_of_month.day
    day = [ contract_day, last_day_of_month ].min
    tentative_end_date.change(day: day)
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

  def fm_old_debt_amount
    paid_interest_payments.map(&:old_debt_amount).sum.to_f.to_currency
  end
end
