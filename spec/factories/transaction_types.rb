# == Schema Information
#
# Table name: transaction_types
#
#  code        :string           not null, primary key
#  description :text
#  is_income   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :transaction_type do
    name { "Additional Loan" }
    description { "Transaction type for additional loan disbursements." }
    is_income { false }

    trait :income_additional_loan do
      code { TransactionType::INCOME_ADDITIONAL_LOAN }
      name { "Additional Loan" }
      description { "Transaction type for additional loan disbursements." }
      is_income { true }
    end

    trait :expense_additional_loan do
      code { TransactionType::EXPENSE_ADDITIONAL_LOAN }
      name { "Additional Loan" }
      description { "Transaction type for additional loan disbursements." }
      is_income { false }
    end
  end
end
