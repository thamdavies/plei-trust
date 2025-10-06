# == Schema Information
#
# Table name: provinces
#
#  code                   :string(20)       not null, primary key
#  code_name              :string(255)
#  full_name              :string(255)      not null
#  full_name_en           :string(255)
#  name                   :string(255)      not null
#  name_en                :string(255)
#  administrative_unit_id :integer
#
# Indexes
#
#  idx_provinces_unit  (administrative_unit_id)
#
# Foreign Keys
#
#  provinces_administrative_unit_id_fkey  (administrative_unit_id => administrative_units.id)
#
FactoryBot.define do
  factory :province do
    code { SecureRandom.hex(5) }
    name { "Gia Lai" }
    name_en { "Gia Lai" }
    code_name { "gia_lai" }
    full_name { "Tỉnh Gia Lai" }
    full_name_en { "Gia Lai Province" }
    administrative_unit { association(:administrative_unit, :province) }
  end
end
