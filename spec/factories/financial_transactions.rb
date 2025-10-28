FactoryBot.define do
  factory :financial_transaction do
    amount { 1000.00 }
    transaction_date { Date.current }
    transaction_number { "TX-001" }
    description { "Sample financial transaction" }
    reference_number { "REF-001" }

    association :created_by, factory: :user
  end
end
