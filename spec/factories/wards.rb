# == Schema Information
#
# Table name: wards
#
#  code                   :string(20)       not null, primary key
#  code_name              :string(255)
#  full_name              :string(255)
#  full_name_en           :string(255)
#  name                   :string(255)      not null
#  name_en                :string(255)
#  province_code          :string(20)
#  administrative_unit_id :integer
#
# Indexes
#
#  idx_wards_province  (province_code)
#  idx_wards_unit      (administrative_unit_id)
#
# Foreign Keys
#
#  wards_administrative_unit_id_fkey  (administrative_unit_id => administrative_units.id)
#  wards_province_code_fkey           (province_code => provinces.code)
#
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
