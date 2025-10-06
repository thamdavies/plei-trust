# == Schema Information
#
# Table name: users
#
#  id                 :uuid             not null, primary key
#  confirmation_token :string(128)
#  email              :string           not null
#  encrypted_password :string(128)      not null
#  full_name          :string           not null
#  phone              :string
#  remember_token     :string(128)      not null
#  status             :string           default("active")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  branch_id          :uuid             not null
#
# Indexes
#
#  index_users_on_branch_id           (branch_id)
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email)
#  index_users_on_remember_token      (remember_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
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
