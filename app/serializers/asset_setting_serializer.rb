# == Schema Information
#
# Table name: customers
#  id                       :uuid             not null, primary key
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
#
# Indexes
#
#  index_customers_on_branch_id      (branch_id)
#  index_customers_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (created_by_id => users.id)
#
class AssetSettingSerializer
  include JSONAPI::Serializer

  attributes :id, :collect_interest_in_advance, :default_contract_term, :default_interest_rate, :interest_period, :interest_calculation_method
end
