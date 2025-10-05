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
class Ward < ApplicationRecord
  self.primary_key = :code

  belongs_to :province, foreign_key: :province_code, primary_key: :code, optional: true
  belongs_to :administrative_unit, optional: true

  has_many :branches
end
