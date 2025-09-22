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
#  province_id    :integer
#  ward_id        :integer
#
class Branch < ApplicationRecord
  has_many :branch_contract_types, dependent: :destroy
  has_many :contract_types, through: :branch_contract_types, source: :contract_type
  has_many :asset_settings, dependent: :destroy
end
