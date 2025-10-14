module Customer::Reader
  extend ActiveSupport::Concern

  def old_debt_amount
    Contract.includes(:paid_interest_payments)
            .where(customer_id: id)
            .map { |c| c.paid_interest_payments.map(&:old_debt_amount).sum.to_f }.sum
  end
end
