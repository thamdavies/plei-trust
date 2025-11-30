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
  WITHDRAWAL_PRINCIPAL = "withdrawal_principal".freeze
  ADDITIONAL_LOAN = "additional_loan".freeze
  CONTRACT_EXTENSION = "contract_extension".freeze
  OUTSTANDING_INTEREST = "outstanding_interest".freeze
  DEBT_REPAYMENT = "debt_repayment".freeze

  scope :income, -> { where(is_income: true) }
  scope :expense, -> { where(is_income: false) }

  class << self
    def interest_payment
      find_by(code: INTEREST_PAYMENT)
    end

    def reduce_principal
      find_by(code: REDUCE_PRINCIPAL)
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

    def outstanding_interest
      find_by(code: OUTSTANDING_INTEREST)
    end

    def debt_repayment
      find_by(code: DEBT_REPAYMENT)
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
          code: WITHDRAWAL_PRINCIPAL,
          name: "Rút vốn",
          description: "Rút vốn khỏi hệ thống",
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
          is_income: true
        },
        {
          code: OUTSTANDING_INTEREST,
          name: "Khách hàng nợ lãi",
          description: "Ghi nhận khách hàng còn nợ tiền lãi hoặc trả tiền thừa được bù trừ vào lãi",
          is_income: false
        },
        {
          code: DEBT_REPAYMENT,
          name: "Khách hàng trả nợ",
          description: "Khách hàng thanh toán nợ (lãi/gốc/phí) vào hệ thống",
          is_income: true
        }
      ]
    end
  end
end
