class CustomInterestPayment
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Attributes for the custom interest payment
  attr_accessor :from_date, :to_date, :days_count,
                :interest_amount, :other_amount,
                :total_interest_amount, :customer_payment_amount,
                :note, :contract_id
end
