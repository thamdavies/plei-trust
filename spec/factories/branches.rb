# == Schema Information
#
# Table name: branches
#
#  id             :uuid             not null, primary key
#  address        :string
#  invest_amount  :decimal(12, 2)
#  name           :string
#  phone          :string
#  representative :string
#  status         :string           default("active")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  province_id    :string
#  ward_id        :string
#
# Indexes
#
#  index_branches_on_province_id  (province_id)
#  index_branches_on_ward_id      (ward_id)
#
# Foreign Keys
#
#  fk_rails_...  (province_id => provinces.code)
#  fk_rails_...  (ward_id => wards.code)
#
FactoryBot.define do
  factory :branch do
    name { "Chi nhánh Pleiku" }
    province { association :province }
    ward { association :ward }
    address { "123 Đường Lê Duẩn" }
    phone { "02693123456" }
    representative { "Đại Nam Money" }
    invest_amount { 500_000.00 }
    status { "active" }
  end
end
