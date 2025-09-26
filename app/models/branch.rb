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
class Branch < ApplicationRecord
  include LargeNumberFields

  large_number_field :invest_amount

  belongs_to :province, optional: true, foreign_key: :province_id, primary_key: :code
  belongs_to :ward, optional: true, foreign_key: :ward_id, primary_key: :code

  has_many :branch_contract_types, dependent: :destroy
  has_many :contract_types, through: :branch_contract_types, source: :contract_type
  has_many :asset_settings, dependent: :destroy

  enum :status, { active: "active", inactive: "inactive" }

  before_validation :format_phone

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name phone representative status]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end

  private

  def format_phone
    self.phone = phone.remove_dots_and_spaces if phone.present?
  end
end
