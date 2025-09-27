# == Schema Information
#
# Table name: contracts
#
#  id                          :uuid             not null, primary key
#  asset_name                  :string
#  code                        :string
#  contract_date               :date
#  contract_term_days          :integer
#  interest_calculation_method :string
#  interest_rate               :decimal(8, 5)
#  loan_amount                 :decimal(15, 2)
#  notes                       :text
#  payment_frequency_days      :integer
#  status                      :string           default("pending")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  asset_setting_id            :uuid
#  branch_id                   :uuid             not null
#  cashier_id                  :uuid             not null
#  contract_type_id            :uuid             not null
#  created_by_id               :uuid             not null
#  customer_id                 :uuid             not null
#
# Indexes
#
#  index_contracts_on_asset_setting_id  (asset_setting_id)
#  index_contracts_on_branch_id         (branch_id)
#  index_contracts_on_cashier_id        (cashier_id)
#  index_contracts_on_contract_type_id  (contract_type_id)
#  index_contracts_on_created_by_id     (created_by_id)
#  index_contracts_on_customer_id       (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (cashier_id => users.id)
#  fk_rails_...  (contract_type_id => contract_types.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (customer_id => customers.id)
#
class Contract < ApplicationRecord
  include AutoCodeGenerator

  acts_as_tenant(:branch)

  belongs_to :customer
  belongs_to :branch
  belongs_to :contract_type
  belongs_to :asset_setting, optional: true
  belongs_to :cashier, class_name: User.name, foreign_key: :cashier_id
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id

  auto_code_config(prefix: "HD", field: :code)
end
