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
#  default_interest_rate       :float
#  default_loan_amount         :decimal(12, 2)
#  default_loan_duration_days  :integer
#  early_termination_fee       :float
#  interest_calculation_method :string           default("monthly")
#  interest_period             :integer
#  liquidation_after_days      :integer
#  management_fee              :float
#  status                      :string           default("active")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
class AssetSetting < ApplicationRecord
  has_many :asset_setting_categories, dependent: :destroy

  def str_id
    id.to_s
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "asset_code", "asset_name", "status" ]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end
end
