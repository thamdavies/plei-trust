# == Schema Information
#
# Table name: asset_settings
#
#  id                          :uuid             not null, primary key
#  asset_appraisal_fee         :float
#  asset_code                  :string
#  asset_name                  :string
#  asset_rental_fee            :float
#  collect_interest_in_advance :boolean          default(FALSE)
#  contract_initiation_fee     :decimal(12, 2)
#  default_contract_term       :integer
#  default_interest_rate       :float
#  default_loan_amount         :decimal(12, 2)
#  early_termination_fee       :float
#  interest_calculation_method :string           default("monthly")
#  interest_period             :integer
#  liquidation_after_days      :integer
#  management_fee              :float
#  status                      :string           default("active")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  branch_id                   :uuid             not null
#
# Indexes
#
#  index_asset_settings_on_branch_id  (branch_id)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#
class AssetSetting < ApplicationRecord
  include LargeNumberFields
  include AssetSetting::Reader

  acts_as_tenant(:branch)

  belongs_to :branch

  has_many :asset_setting_categories, dependent: :destroy
  has_many :asset_setting_attributes, dependent: :destroy
  has_many :contract_types, through: :asset_setting_categories, source: :contract_type

  # Large number fields (lưu dưới dạng thousands)
  large_number_field :default_loan_amount
  large_number_field :contract_initiation_fee
  large_number_field :asset_appraisal_fee
  large_number_field :asset_rental_fee
  large_number_field :early_termination_fee
  large_number_field :management_fee

  validates :asset_code, presence: true, uniqueness: { scope: :branch_id }

  accepts_nested_attributes_for :asset_setting_categories,
                                allow_destroy: true,
                                reject_if: :all_blank

  accepts_nested_attributes_for :asset_setting_attributes,
                                allow_destroy: true,
                                reject_if: :all_blank

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "asset_code", "asset_name", "status" ]
    end

    def ransackable_associations(auth_object = nil)
     [ "asset_setting_categories" ]
    end
  end
end
