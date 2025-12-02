# == Schema Information
#
# Table name: contracts
#
#  id                          :uuid             not null, primary key
#  asset_name                  :string
#  code                        :string
#  collect_interest_in_advance :boolean          default(FALSE)
#  contract_date               :date
#  contract_term               :integer
#  contract_type_code          :string           not null
#  interest_calculation_method :string
#  interest_period             :integer
#  interest_rate               :decimal(8, 5)
#  loan_amount                 :decimal(15, 4)
#  note                        :text
#  status                      :string           default("active")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  asset_setting_id            :uuid
#  branch_id                   :uuid             not null
#  cashier_id                  :uuid             not null
#  created_by_id               :uuid             not null
#  customer_id                 :uuid             not null
#
# Indexes
#
#  index_contracts_on_asset_setting_id  (asset_setting_id)
#  index_contracts_on_branch_id         (branch_id)
#  index_contracts_on_cashier_id        (cashier_id)
#  index_contracts_on_created_by_id     (created_by_id)
#  index_contracts_on_customer_id       (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (cashier_id => users.id)
#  fk_rails_...  (contract_type_code => contract_types.code)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (customer_id => customers.id)
#
FactoryBot.define do
  factory :contract do
    asset_name { "Default Asset" }
    code { "CTR-001" }
    collect_interest_in_advance { false }
    contract_date { Date.current }
    contract_term { 60 }
    interest_calculation_method { "daily_per_million" }
    interest_rate { 10 }
    loan_amount { 5_000_000.00 }
    note { "This is a sample contract." }
    interest_period { 30 }
    status { "active" }

    association :branch
    association :cashier, factory: :user
    association :contract_type
    association :created_by, factory: :user
    association :customer

    trait :daily_fixed do
      interest_calculation_method { "daily_fixed" }
    end

    trait :weekly_percent do
      interest_calculation_method { "weekly_percent" }
      interest_period { 4 }
      interest_rate { 1 }
      contract_term { 12 }
    end

    trait :monthly_30 do
      interest_calculation_method { "monthly_30" }
      interest_period { 1 }
      interest_rate { 0.5 }
      contract_term { 3 }
    end

    trait :monthly_calendar do
      interest_calculation_method { "monthly_calendar" }
      interest_period { 1 }
      interest_rate { 0.5 }
      contract_term { 3 }
    end

    trait :weekly_fixed do
      interest_calculation_method { "weekly_fixed" }
    end
  end
end
