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
class AssetSettingSerializer
  include JSONAPI::Serializer

  attributes :id, :collect_interest_in_advance, :default_contract_term, :default_interest_rate, :interest_period, :interest_calculation_method
end
