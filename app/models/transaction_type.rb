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
  # Transaction type codes, run TransactionType.seed_default_types to create default types after adding new types
  INTEREST_PAYMENT = "interest_payment".freeze
  REDUCE_PRINCIPAL = "reduce_principal".freeze
  LOAN_DISBURSEMENT = "loan_disbursement".freeze
  FEE_PAYMENT = "fee_payment".freeze
  PENALTY_PAYMENT = "penalty_payment".freeze
  DEPOSIT = "deposit".freeze
  WITHDRAWAL_PRINCIPAL = "withdrawal_principal".freeze
  TRANSFER_IN = "transfer_in".freeze
  TRANSFER_OUT = "transfer_out".freeze
  REFUND = "refund".freeze
  OTHER_INCOME = "other_income".freeze
  OTHER_EXPENSE = "other_expense".freeze
  ADDITIONAL_LOAN = "additional_loan".freeze
  CONTRACT_EXTENSION = "contract_extension".freeze

  scope :income, -> { where(is_income: true) }
  scope :expense, -> { where(is_income: false) }

  class << self
    def interest_payment
      find_by(code: INTEREST_PAYMENT)
    end

    def reduce_principal
      find_by(code: REDUCE_PRINCIPAL)
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

    def withdrawal_principal
      find_by(code: WITHDRAWAL_PRINCIPAL)
    end

    def additional_loan
      find_by(code: ADDITIONAL_LOAN)
    end

    def contract_extension
      find_by(code: CONTRACT_EXTENSION)
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
          code: REDUCE_PRINCIPAL,
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
          code: WITHDRAWAL_PRINCIPAL,
          name: "Rút vốn",
          description: "Rút vốn khỏi hệ thống",
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
        },
        {
          code: ADDITIONAL_LOAN,
          name: "Vay thêm",
          description: "Giải ngân tiền vay thêm cho khách hàng",
          is_income: false
        },
        {
          code: CONTRACT_EXTENSION,
          name: "Gia hạn hợp đồng",
          description: "Phí gia hạn hợp đồng hoặc ghi nhận gia hạn",
          is_income: true  # Có thể thu phí gia hạn
        }
      ]
    end
  end
end
