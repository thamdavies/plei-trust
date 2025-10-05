FactoryBot.define do
  factory :contract do
    asset_name { "Default Asset" }
    code { "CTR-001" }
    collect_interest_in_advance { false }
    contract_date { Date.current }
    contract_term_days { 60 }
    interest_calculation_method { "daily_per_million" }
    interest_rate { 10 }
    loan_amount { 5_000_000.00 }
    notes { "This is a sample contract." }
    payment_frequency_days { 30 }
    status { "active" }

    association :branch
    association :cashier, factory: :user
    association :contract_type
    association :created_by, factory: :user
    association :customer
  end
end
