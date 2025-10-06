# == Schema Information
#
# Table name: contract_types
#
#  id          :uuid             not null, primary key
#  code        :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :contract_type do
    id { SecureRandom.uuid }
    code { [ "pawn", "capital" ].sample }
    description { Faker::Lorem.sentence }
    name { Faker::Name.name }
  end
end
