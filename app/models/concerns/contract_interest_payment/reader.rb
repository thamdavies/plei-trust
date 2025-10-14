module ContractInterestPayment::Reader
  extend ActiveSupport::Concern

  def old_debt_amount
    (total_amount - total_paid) * 1_000
  end
end
