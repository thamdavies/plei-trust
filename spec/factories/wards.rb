FactoryBot.define do
  factory :ward do
    code { Faker::Number.unique.number(digits: 5).to_s }
    name { "Pleiku" }
    name_en { "Pleiku" }
    code_name { "pleiku" }
    full_name { "Phường Pleiku" }
    full_name_en { "Pleiku Ward" }
    province { association :province }
    administrative_unit { association :administrative_unit, :ward }
  end
end
