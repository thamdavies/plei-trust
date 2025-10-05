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
