#  id                 :uuid             not null, primary key
#  confirmation_token :string(128)
#  email              :string           not null
#  encrypted_password :string(128)      not null
#  full_name          :string           not null
#  phone              :string
#  remember_token     :string(128)      not null
#  status             :string           default("active")
#
FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
    full_name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    remember_token { SecureRandom.hex(10) }
    status { "active" }
    branch { association :branch }
  end
end
