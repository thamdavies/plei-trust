# == Schema Information
#
# Table name: branches
#
#  id             :uuid             not null, primary key
#  address        :string
#  invest_amount  :decimal(12, 4)
#  name           :string
#  phone          :string
#  representative :string
#  status         :string           default("active")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  province_id    :string
#  ward_id        :string
#
# Indexes
#
#  index_branches_on_province_id  (province_id)
#  index_branches_on_ward_id      (ward_id)
#
# Foreign Keys
#
#  fk_rails_...  (province_id => provinces.code)
#  fk_rails_...  (ward_id => wards.code)
#
class Branch < ApplicationRecord
  include PublicActivity::Model
  include LargeNumberFields
  include Branch::Reader

  large_number_field :invest_amount

  belongs_to :province, optional: true, foreign_key: :province_id, primary_key: :code
  belongs_to :ward, optional: true, foreign_key: :ward_id, primary_key: :code

  has_one :seed_capital_customer, -> { where(is_seed_capital: true) }, class_name: Customer.name, foreign_key: :branch_id, primary_key: :id

  has_many :branch_contract_types, dependent: :destroy
  has_many :contract_types, through: :branch_contract_types, source: :contract_type
  has_many :asset_settings, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :daily_balances, dependent: :destroy
  has_many :financial_transactions, as: :recordable, dependent: :destroy
  has_many :interest_payments, class_name: ContractInterestPayment.name, dependent: :destroy
  has_many :reminders, class_name: ContractReminder.name, dependent: :destroy

  has_many :income_transactions, -> { joins(:transaction_type).where(transaction_types: { is_income: true }) }, class_name: FinancialTransaction.name, foreign_key: :recordable_id, primary_key: :id
  has_many :expense_transactions, -> { joins(:transaction_type).where(transaction_types: { is_income: false }) }, class_name: FinancialTransaction.name, foreign_key: :recordable_id, primary_key: :id

  has_many :income_principals, -> { where(transaction_type_code: TransactionType::INCOME_PRINCIPAL) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :expense_principals, -> { where(transaction_type_code: TransactionType::EXPENSE_PRINCIPAL) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :income_additional_loans, -> { where(transaction_type_code: TransactionType::INCOME_ADDITIONAL_LOAN) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :expense_additional_loans, -> { where(transaction_type_code: TransactionType::EXPENSE_ADDITIONAL_LOAN) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :income_withdrawal_principals, -> { where(transaction_type_code: TransactionType::INCOME_WITHDRAWAL_PRINCIPAL) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :expense_withdrawal_principals, -> { where(transaction_type_code: TransactionType::EXPENSE_WITHDRAWAL_PRINCIPAL) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :income_interest_overpayments, -> { where(transaction_type_code: TransactionType::INCOME_INTEREST_OVERPAYMENT) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :expense_interest_overpayments, -> { where(transaction_type_code: TransactionType::EXPENSE_INTEREST_OVERPAYMENT) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :income_debt_repayments, -> { where(transaction_type_code: TransactionType::INCOME_DEBT_REPAYMENT) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :expense_debt_repayments, -> { where(transaction_type_code: TransactionType::EXPENSE_DEBT_REPAYMENT) }, class_name: FinancialTransaction.name, as: :recordable, dependent: :destroy
  has_many :activities, -> { order("id DESC") }, class_name: PublicActivity::Activity.name, as: :trackable, dependent: :destroy

  # Views
  has_many :active_contracts, -> { where(status: :active) }, class_name: Contract.name
  has_many :closed_contracts, -> { where(status: :closed) }, class_name: Contract.name

  has_many :on_time_contracts, class_name: ViewOnTimeContract.name
  has_many :interest_late_contracts, class_name: ViewInterestLateContract.name
  has_many :overdue_contracts, class_name: ViewOverdueContract.name

  enum :status, { active: "active", inactive: "inactive" }

  before_validation :format_phone

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name phone representative status]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end

  private

  def format_phone
    self.phone = phone.remove_dots_and_spaces if phone.present?
  end
end
