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
class FinancialTransaction < ApplicationRecord
  include LargeNumberFields
  include AutoCodeGenerator
  include PublicActivity::Model

  auto_code_config(prefix: "TX", field: :transaction_number)
  large_number_field :amount

  belongs_to :branch
  belongs_to :transactable, polymorphic: true, optional: true
  belongs_to :transaction_type, foreign_key: :transaction_type_code, primary_key: :code
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id, optional: true

  scope :income, -> { joins(:transaction_type).where(transaction_types: { is_income: true }) }
  scope :expense, -> { joins(:transaction_type).where(transaction_types: { is_income: false }) }

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "party_name", "transaction_type_code", "transaction_date" ]
    end

    def ransackable_associations(auth_object = nil)
      [ "transaction_type" ]
    end
  end
end
