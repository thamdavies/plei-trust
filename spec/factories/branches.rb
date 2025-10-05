FactoryBot.define do
  factory :branch do
    name { "Chi nhánh Pleiku" }
    province { association :province }
    ward { association :ward }
    address { "123 Đường Lê Duẩn" }
    phone { "02693123456" }
    representative { "Đại Nam Money" }
    invest_amount { 500_000.00 }
    status { "active" }
  end
end
