FactoryBot.define do
  factory :contract_type do
    id { SecureRandom.uuid }
    code { [ "pawn", "capital" ].sample }
    description { Faker::Lorem.sentence }
    name { Faker::Name.name }
  end
end
