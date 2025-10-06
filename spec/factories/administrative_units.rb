# == Schema Information
#
# Table name: administrative_units
#
#  id            :integer          not null, primary key
#  code_name     :string(255)
#  code_name_en  :string(255)
#  full_name     :string(255)
#  full_name_en  :string(255)
#  short_name    :string(255)
#  short_name_en :string(255)
#
FactoryBot.define do
  factory :administrative_unit do
    id { Faker::Number.unique.number(digits: 3) }
    full_name { "MyString" }
    full_name_en { "MyString" }
    short_name { "MyString" }
    short_name_en { "MyString" }
    code_name { "MyString" }
    code_name_en { "MyString" }

    trait :municipality do
      full_name { "Thành phố trực thuộc trung ương" }
      full_name_en { "Municipality" }
      short_name { "Thành phố" }
      short_name_en { "City" }
      code_name { "thanh_pho_truc_thuoc_trung_uong" }
      code_name_en { "municipality" }
    end

    trait :province do
      full_name { "Tỉnh" }
      full_name_en { "Province" }
      short_name { "Tỉnh" }
      short_name_en { "Province" }
      code_name { "tinh" }
      code_name_en { "province" }
    end

    trait :ward do
      full_name { "Phường" }
      full_name_en { "Ward" }
      short_name { "Phường" }
      short_name_en { "Ward" }
      code_name { "phuong" }
      code_name_en { "ward" }
    end

    trait :commune do
      full_name { "Xã" }
      full_name_en { "Commune" }
      short_name { "Xã" }
      short_name_en { "Commune" }
      code_name { "xa" }
      code_name_en { "commune" }
    end

    trait :special_administrative_region do
      full_name { "Đặc khu tại hải đảo" }
      full_name_en { "Special administrative region" }
      short_name { "Đặc khu" }
      short_name_en { "Special administrative region" }
      code_name { "dac_khu" }
      code_name_en { "special_administrative_region" }
    end
  end
end
