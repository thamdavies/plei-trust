module TransactionType::Core
  extend ActiveSupport::Concern

  included do
    INCOME_INTEREST = "income_interest".freeze
    INCOME_PRINCIPAL = "income_principal".freeze # Trả gốc
    INCOME_WITHDRAWAL_PRINCIPAL = "income_withdrawal_principal".freeze # Rút vốn
    INCOME_ADDITIONAL_LOAN = "income_additional_loan".freeze
    INCOME_CONTRACT_EXTENSION = "income_contract_extension".freeze
    INCOME_OUTSTANDING_INTEREST = "income_outstanding_interest".freeze # Khách hàng nợ lãi
    INCOME_DEBT_REPAYMENT = "income_debt_repayment".freeze # Khách hàng trả nợ

    EXPENSE_INTEREST = "expense_interest".freeze
    EXPENSE_PRINCIPAL = "expense_principal".freeze # Trả gốc
    EXPENSE_WITHDRAWAL_PRINCIPAL = "expense_withdrawal_principal".freeze # Rút vốn
    EXPENSE_ADDITIONAL_LOAN = "expense_additional_loan".freeze
    EXPENSE_CONTRACT_EXTENSION = "expense_contract_extension".freeze
    EXPENSE_OUTSTANDING_INTEREST = "expense_outstanding_interest".freeze # Khách hàng nợ lãi
    EXPENSE_DEBT_REPAYMENT = "expense_debt_repayment".freeze # Khách hàng trả nợ

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

    INCOME_TYPES = [
      INCOME_MISC,
      INCOME_FUND_RETURN,
      INCOME_DEBT_COLLECTION,
      INCOME_ADVANCE_COLLECTION,
      INCOME_PENALTY,
      INCOME_COMMISSION,
      INCOME_TICKET_OR_OFFICE,
      INCOME_CAR_SALE,
      INCOME_FILE_FEE,
      INCOME_OTHER_INTEREST
    ].freeze

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

    EXPENSE_TYPES = [
      EXPENSE_MISC,
      EXPENSE_SALARY,
      EXPENSE_PAY_INTEREST,
      EXPENSE_CONSUMPTION,
      EXPENSE_PAY_FUND,
      EXPENSE_ADVANCE,
      EXPENSE_COMMISSION,
      EXPENSE_TICKET_OR_OFFICE,
      EXPENSE_CAR_PURCHASE,
      EXPENSE_CAR_PREP_FILE,
      EXPENSE_HOUSE_RENT,
      EXPENSE_LEND_MONEY
    ].freeze
  end

  class_methods do
    def seed_default_types
      return unless Rails.env.development? || Rails.env.test?

      FinancialTransaction.delete_all
      TransactionType.delete_all

      payload = []

      default_types.each do |type_data|
        payload << type_data
      end

      TransactionType.insert_all(payload)
    end

    private

    def default_types
      [
        {
          code: INCOME_INTEREST,
          name: "Trả lãi",
          description: "Trả lãi được xem là thu nhập",
          is_income: true
        },
        {
          code: INCOME_PRINCIPAL,
          name: "Rút gốc",
          description: "Rút gốc được xem là thu nhập",
          is_income: true
        },
        {
          code: INCOME_WITHDRAWAL_PRINCIPAL,
          name: "Rút vốn / Đóng hợp đồng",
          description: "Rút vốn hoặc đóng hợp đồng được xem là thu nhập",
          is_income: true
        },
        {
          code: INCOME_ADDITIONAL_LOAN,
          name: "Vay thêm",
          description: "Vay thêm được xem là thu nhập",
          is_income: true
        },
        {
          code: INCOME_CONTRACT_EXTENSION,
          name: "Gia hạn hợp đồng",
          description: "Gia hạn hợp đồng được xem là thu nhập",
          is_income: true
        },
        {
          code: INCOME_OUTSTANDING_INTEREST,
          name: "Khách hàng nợ lãi",
          description: "Khách hàng nợ lãi được xem là thu nhập",
          is_income: true
        },
        {
          code: INCOME_DEBT_REPAYMENT,
          name: "Khách hàng trả nợ",
          description: "Khách hàng trả nợ được xem là thu nhập",
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
        # Expense types
        {
          code: EXPENSE_INTEREST,
          name: "Trả lãi",
          description: "Trả lãi được xem là chi phí",
          is_income: false
        },
        {
          code: EXPENSE_PRINCIPAL,
          name: "Trả gốc",
          description: "Trả gốc được xem là chi phí",
          is_income: false
        },
        {
          code: EXPENSE_WITHDRAWAL_PRINCIPAL,
          name: "Rút vốn / Đóng hợp đồng",
          description: "Rút vốn hoặc đóng hợp đồng được xem là chi phí",
          is_income: false
        },
        {
          code: EXPENSE_ADDITIONAL_LOAN,
          name: "Vay thêm",
          description: "Vay thêm được xem là chi phí",
          is_income: false
        },
        {
          code: EXPENSE_CONTRACT_EXTENSION,
          name: "Gia hạn hợp đồng",
          description: "Gia hạn hợp đồng được xem là chi phí",
          is_income: false
        },
        {
          code: EXPENSE_OUTSTANDING_INTEREST,
          name: "Khách hàng nợ lãi",
          description: "Khách hàng nợ lãi được xem là chi phí",
          is_income: false
        },
        {
          code: EXPENSE_DEBT_REPAYMENT,
          name: "Khách hàng trả nợ",
          description: "Khách hàng trả nợ được xem là chi phí",
          is_income: false
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
