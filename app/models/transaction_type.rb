# == Schema Information
#
# Table name: transaction_types
#
#  id          :uuid             not null, primary key
#  code        :string
#  description :text
#  is_income   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TransactionType < ApplicationRecord
  # Transaction type codes
  INTEREST_PAYMENT = "interest_payment".freeze
  PRINCIPAL_PAYMENT = "principal_payment".freeze
  LOAN_DISBURSEMENT = "loan_disbursement".freeze
  FEE_PAYMENT = "fee_payment".freeze
  PENALTY_PAYMENT = "penalty_payment".freeze
  DEPOSIT = "deposit".freeze
  WITHDRAWAL = "withdrawal".freeze
  TRANSFER_IN = "transfer_in".freeze
  TRANSFER_OUT = "transfer_out".freeze
  REFUND = "refund".freeze
  OTHER_INCOME = "other_income".freeze
  OTHER_EXPENSE = "other_expense".freeze

  scope :income, -> { where(is_income: true) }
  scope :expense, -> { where(is_income: false) }

  class << self
    def interest_payment
      find_by(code: INTEREST_PAYMENT)
    end

    def principal_payment
      find_by(code: PRINCIPAL_PAYMENT)
    end

    def loan_disbursement
      find_by(code: LOAN_DISBURSEMENT)
    end

    def fee_payment
      find_by(code: FEE_PAYMENT)
    end

    def penalty_payment
      find_by(code: PENALTY_PAYMENT)
    end

    def deposit
      find_by(code: DEPOSIT)
    end

    def withdrawal
      find_by(code: WITHDRAWAL)
    end

    def seed_default_types
      default_types.each do |type_data|
        find_or_create_by(code: type_data[:code]) do |transaction_type|
          transaction_type.assign_attributes(type_data)
        end
      end
    end

    private

    def default_types
      [
        {
          code: INTEREST_PAYMENT,
          name: "Đóng lãi",
          description: "Thu tiền lãi từ khách hàng",
          is_income: true
        },
        {
          code: PRINCIPAL_PAYMENT,
          name: "Trả gốc",
          description: "Thu tiền gốc từ khách hàng",
          is_income: true
        },
        {
          code: LOAN_DISBURSEMENT,
          name: "Giải ngân",
          description: "Giải ngân tiền vay cho khách hàng",
          is_income: false
        },
        {
          code: FEE_PAYMENT,
          name: "Thu phí",
          description: "Thu các loại phí từ khách hàng",
          is_income: true
        },
        {
          code: PENALTY_PAYMENT,
          name: "Thu phạt",
          description: "Thu tiền phạt từ khách hàng",
          is_income: true
        },
        {
          code: DEPOSIT,
          name: "Nộp tiền",
          description: "Nộp tiền vào hệ thống",
          is_income: true
        },
        {
          code: WITHDRAWAL,
          name: "Rút tiền",
          description: "Rút tiền từ hệ thống",
          is_income: false
        },
        {
          code: TRANSFER_IN,
          name: "Chuyển vào",
          description: "Tiền chuyển vào từ bên ngoài",
          is_income: true
        },
        {
          code: TRANSFER_OUT,
          name: "Chuyển ra",
          description: "Tiền chuyển ra bên ngoài",
          is_income: false
        },
        {
          code: REFUND,
          name: "Hoàn trả",
          description: "Hoàn trả tiền cho khách hàng",
          is_income: false
        },
        {
          code: OTHER_INCOME,
          name: "Thu nhập khác",
          description: "Các khoản thu nhập khác",
          is_income: true
        },
        {
          code: OTHER_EXPENSE,
          name: "Chi phí khác",
          description: "Các khoản chi phí khác",
          is_income: false
        }
      ]
    end
  end
end
