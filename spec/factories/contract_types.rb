# == Schema Information
#
# Table name: contract_types
#
#  code        :string           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :contract_type do
    code { :capital }
    description { Faker::Lorem.sentence }
    name { Faker::Name.name }

    trait :pawn do
      code { :pawn }
    end

    trait :installment do
      code { :installment }
    end

    trait :credit do
      code { :credit }
    end
  end
end
