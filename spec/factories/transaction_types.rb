FactoryBot.define do
  factory :transaction_type do
    code { TransactionType::ADDITIONAL_LOAN }
    name { "Additional Loan" }
    description { "Transaction type for additional loan disbursements." }
    is_income { false }

    trait :additional_loan do
      code { TransactionType::ADDITIONAL_LOAN }
      name { "Additional Loan" }
      description { "Transaction type for additional loan disbursements." }
      is_income { false }
    end
  end
end
