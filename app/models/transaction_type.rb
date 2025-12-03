# == Schema Information
#
# Table name: transaction_types
#
#  code        :string           not null, primary key
#  description :text
#  is_income   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TransactionType < ApplicationRecord
  include TransactionType::Core

  # Transaction type codes, run TransactionType.seed_default_types to create default types after adding new types
  scope :income_types, -> { where(code: INCOME_TYPES) }
  scope :expense_types, -> { where(code: EXPENSE_TYPES) }

  scope :income, -> { where(is_income: true) }
  scope :expense, -> { where(is_income: false) }
end
