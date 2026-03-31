# == Schema Information
#
# Table name: financial_transactions
#
#  id                     :uuid             not null, primary key
#  amount                 :decimal(15, 4)   not null
#  canceled_at            :datetime
#  description            :string
#  notes                  :text
#  party_name             :string
#  reference_number       :string
#  transactable_type      :string
#  transactable_type_code :string
#  transaction_date       :date             not null
#  transaction_number     :string           not null
#  transaction_type_code  :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  branch_id              :uuid             not null
#  created_by_id          :uuid             not null
#  transactable_id        :uuid
#
# Indexes
#
#  idx_on_transactable_type_transactable_id_f09fb7b364    (transactable_type,transactable_id)
#  index_financial_transactions_on_branch_id              (branch_id)
#  index_financial_transactions_on_created_by_id          (created_by_id)
#  index_financial_transactions_on_transaction_type_code  (transaction_type_code)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (transaction_type_code => transaction_types.code)
#
FactoryBot.define do
  factory :financial_transaction do
    amount { 1000.00 }
    transaction_date { Date.current }
    transaction_number { "TX-001" }
    description { "Sample financial transaction" }
    reference_number { "REF-001" }

    association :created_by, factory: :user
  end
end
