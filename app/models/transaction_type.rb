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

  class_attribute :config, default: {
    additional_loan: {
      capital: {
        update: INCOME_ADDITIONAL_LOAN
      },
      pawn: {
        update: EXPENSE_ADDITIONAL_LOAN
      },
      installment: {
        update: EXPENSE_ADDITIONAL_LOAN
      }
    },
    reduce_principal: {
      capital: {
        update: EXPENSE_PRINCIPAL
      },
      pawn: {
        update: INCOME_PRINCIPAL
      },
      installment: {
        update: INCOME_PRINCIPAL
      }
    },
    withdraw_principal: {
      capital: {
        update: EXPENSE_WITHDRAWAL_PRINCIPAL
      },
      pawn: {
        update: INCOME_WITHDRAWAL_PRINCIPAL
      },
      installment: {
        update: INCOME_WITHDRAWAL_PRINCIPAL
      }
    },
    interest_payment: {
      capital: {
        update: EXPENSE_INTEREST,
        cancel: INCOME_INTEREST
      },
      pawn: {
        update: INCOME_INTEREST,
        cancel: EXPENSE_INTEREST
      },
      installment: {
        update: INCOME_INTEREST,
        cancel: EXPENSE_INTEREST
      }
    },
    debt_repayment: {
      capital: {
        destroy: EXPENSE_DEBT_REPAYMENT
      },
      pawn: {
        destroy: INCOME_DEBT_REPAYMENT
      },
      installment: {
        destroy: INCOME_DEBT_REPAYMENT
      }
    },
    interest_overpayment: {
      capital: {
        create: INCOME_INTEREST_OVERPAYMENT
      },
      pawn: {
        create: EXPENSE_INTEREST_OVERPAYMENT
      },
      installment: {
        create: EXPENSE_INTEREST_OVERPAYMENT
      }
    }
  }

  # Transaction type codes, run TransactionType.seed_default_types to create default types after adding new types
  scope :income_types, -> { where(code: INCOME_TYPES) }
  scope :expense_types, -> { where(code: EXPENSE_TYPES) }

  scope :income, -> { where(is_income: true) }
  scope :expense, -> { where(is_income: false) }
end
