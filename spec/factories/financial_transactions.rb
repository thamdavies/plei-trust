# == Schema Information
#
# Table name: financial_transactions
#
#  id                  :uuid             not null, primary key
#  amount              :decimal(15, 2)   not null
#  description         :string
#  party_name          :string
#  recordable_type     :string           not null
#  reference_number    :string
#  transaction_date    :date             not null
#  transaction_number  :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  created_by_id       :uuid             not null
#  recordable_id       :uuid             not null
#  transaction_type_id :uuid             not null
#
# Indexes
#
#  index_financial_transactions_on_created_by_id        (created_by_id)
#  index_financial_transactions_on_transaction_type_id  (transaction_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (transaction_type_id => transaction_types.id)
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
