# == Schema Information
#
# Table name: financial_transactions
#
#  id                    :uuid             not null, primary key
#  amount                :decimal(15, 4)   not null
#  description           :string
#  party_name            :string
#  recordable_type       :string           not null
#  reference_number      :string
#  transaction_date      :date             not null
#  transaction_number    :string           not null
#  transaction_type_code :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  created_by_id         :uuid             not null
#  recordable_id         :uuid             not null
#
# Indexes
#
#  index_financial_transactions_on_created_by_id          (created_by_id)
#  index_financial_transactions_on_transaction_type_code  (transaction_type_code)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (transaction_type_code => transaction_types.code)
#
class FinancialTransaction < ApplicationRecord
  include LargeNumberFields
  include AutoCodeGenerator
  include PublicActivity::Model

  auto_code_config(prefix: "TX", field: :transaction_number)
  large_number_field :amount

  belongs_to :recordable, polymorphic: true
  belongs_to :transaction_type, foreign_key: :transaction_type_code, primary_key: :code
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id, optional: true

  scope :income, -> { joins(:transaction_type).where("transaction_types.code LIKE 'income_%'") }
  scope :expense, -> { joins(:transaction_type).where("transaction_types.code LIKE 'expense_%'") }
end
