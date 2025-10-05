FactoryBot.define do
  factory :customer do
    address { "123 Main St" }
    customer_code { "KH-001" }
    full_name { "John Doe" }
    is_seed_capital { false }
    national_id { "A123456789" }
    national_id_issued_date { Date.current - 1.year }
    national_id_issued_place { "City Hall" }
    phone { "1234567890" }
    status { "active" }

    association :branch
    association :created_by, factory: :user
  end
end
