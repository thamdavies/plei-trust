module Customer::Reader
  extend ActiveSupport::Concern

  def old_debt_amount
    Contract.where(customer_id: id).map { |c| c.old_debt_amount }.sum.to_f
  end
end
