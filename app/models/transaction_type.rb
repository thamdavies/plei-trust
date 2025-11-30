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

  # Additional income-prefixed codes (English constants)
  INCOME_MISC = "income_misc".freeze
  INCOME_FUND_RETURN = "income_fund_return".freeze
  INCOME_DEBT_COLLECTION = "income_debt_collection".freeze
  INCOME_ADVANCE_COLLECTION = "income_advance_collection".freeze
  INCOME_PENALTY = "income_penalty".freeze
  INCOME_COMMISSION = "income_commission".freeze
  INCOME_TICKET_OR_OFFICE = "income_ticket_or_office".freeze
  INCOME_CAR_SALE = "income_car_sale".freeze
  INCOME_FILE_FEE = "income_file_fee".freeze
  INCOME_OTHER_INTEREST = "income_other_interest".freeze

  # Additional expense-prefixed codes
  EXPENSE_MISC = "expense_misc".freeze
  EXPENSE_SALARY = "expense_salary".freeze
  EXPENSE_PAY_INTEREST = "expense_pay_interest".freeze
  EXPENSE_CONSUMPTION = "expense_consumption".freeze
  EXPENSE_PAY_FUND = "expense_pay_fund".freeze
  EXPENSE_ADVANCE = "expense_advance".freeze
  EXPENSE_COMMISSION = "expense_commission".freeze
  EXPENSE_TICKET_OR_OFFICE = "expense_ticket_or_office".freeze
  EXPENSE_CAR_PURCHASE = "expense_car_purchase".freeze
  EXPENSE_CAR_PREP_FILE = "expense_car_prep_file".freeze
  EXPENSE_HOUSE_RENT = "expense_house_rent".freeze
  EXPENSE_LEND_MONEY = "expense_lend_money".freeze

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
        },
        {
          code: INCOME_MISC,
          name: "Thu khác",
          description: "Các khoản thu khác không thuộc nhóm cụ thể",
          is_income: true
        },
        {
          code: INCOME_FUND_RETURN,
          name: "Thu trả quỹ",
          description: "Khoản tiền thu về từ việc khách hàng/đối tác trả lại quỹ",
          is_income: true
        },
        {
          code: INCOME_DEBT_COLLECTION,
          name: "Thu tiền nợ",
          description: "Thu hồi các khoản nợ tồn đọng",
          is_income: true
        },
        {
          code: INCOME_ADVANCE_COLLECTION,
          name: "Thu tiền ứng",
          description: "Thu lại khoản tiền đã ứng trước",
          is_income: true
        },
        {
          code: INCOME_PENALTY,
          name: "Thu tiền phạt",
          description: "Thu tiền phạt vi phạm hợp đồng/quy định",
          is_income: true
        },
        {
          code: INCOME_COMMISSION,
          name: "Hoa hồng",
          description: "Thu nhập từ hoa hồng",
          is_income: true
        },
        {
          code: INCOME_TICKET_OR_OFFICE,
          name: "Thu vé hoặc văn phòng",
          description: "Thu phí vé hoặc thu phí văn phòng",
          is_income: true
        },
        {
          code: INCOME_CAR_SALE,
          name: "Bán Xe",
          description: "Doanh thu từ việc bán xe",
          is_income: true
        },
        {
          code: INCOME_FILE_FEE,
          name: "Thu hồ sơ",
          description: "Thu phí hồ sơ/thủ tục",
          is_income: true
        },
        {
          code: INCOME_OTHER_INTEREST,
          name: "Thu lãi khác",
          description: "Các khoản thu lãi khác ngoài lãi thông thường",
          is_income: true
        },
        {
          code: EXPENSE_MISC,
          name: "Chi khác",
          description: "Các khoản chi khác",
          is_income: false
        },
        {
          code: EXPENSE_SALARY,
          name: "Trả lương",
          description: "Chi trả lương nhân viên",
          is_income: false
        },
        {
          code: EXPENSE_PAY_INTEREST,
          name: "Trả lãi",
          description: "Chi trả lãi vay",
          is_income: false
        },
        {
          code: EXPENSE_CONSUMPTION,
          name: "Chi tiêu dùng",
          description: "Chi tiêu dùng cá nhân/nội bộ",
          is_income: false
        },
        {
          code: EXPENSE_PAY_FUND,
          name: "Chi trả quỹ",
          description: "Chi trả tiền quỹ",
          is_income: false
        },
        {
          code: EXPENSE_ADVANCE,
          name: "Tạm ứng",
          description: "Chi tạm ứng",
          is_income: false
        },
        {
          code: EXPENSE_COMMISSION,
          name: "Hoa hồng",
          description: "Chi hoa hồng môi giới",
          is_income: false
        },
        {
          code: EXPENSE_TICKET_OR_OFFICE,
          name: "Chi vé hoặc văn phòng",
          description: "Chi phí vé hoặc văn phòng",
          is_income: false
        },
        {
          code: EXPENSE_CAR_PURCHASE,
          name: "Chi mua xe",
          description: "Chi tiền mua xe",
          is_income: false
        },
        {
          code: EXPENSE_CAR_PREP_FILE,
          name: "Chi Dọn xe - Hồ sơ",
          description: "Chi phí dọn xe và làm hồ sơ",
          is_income: false
        },
        {
          code: EXPENSE_HOUSE_RENT,
          name: "Chi Tiền Nhà",
          description: "Chi phí thuê nhà/mặt bằng",
          is_income: false
        },
        {
          code: EXPENSE_LEND_MONEY,
          name: "Chi mượn tiền",
          description: "Chi cho mượn tiền",
          is_income: false
        }
      ]
    end
  end
end
