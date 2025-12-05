# == Schema Information
#
# Table name: contracts
#
#  id                          :uuid             not null, primary key
#  asset_name                  :string
#  code                        :string
#  collect_interest_in_advance :boolean          default(FALSE)
#  contract_date               :date
#  contract_ended_at           :datetime
#  contract_term               :integer
#  contract_type_code          :string           not null
#  interest_calculation_method :string
#  interest_period             :integer
#  interest_rate               :decimal(8, 5)
#  is_default_capital          :boolean          default(FALSE), not null
#  loan_amount                 :decimal(15, 4)
#  note                        :text
#  status                      :string           default("active")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  asset_setting_id            :uuid
#  branch_id                   :uuid             not null
#  cashier_id                  :uuid             not null
#  created_by_id               :uuid             not null
#  customer_id                 :uuid             not null
#
# Indexes
#
#  index_contracts_on_asset_setting_id  (asset_setting_id)
#  index_contracts_on_branch_id         (branch_id)
#  index_contracts_on_cashier_id        (cashier_id)
#  index_contracts_on_created_by_id     (created_by_id)
#  index_contracts_on_customer_id       (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (cashier_id => users.id)
#  fk_rails_...  (contract_type_code => contract_types.code)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (customer_id => customers.id)
#
class Contract < ApplicationRecord
  include PublicActivity::Model
  include AutoCodeGenerator
  include LargeNumberFields
  include Contract::Reader
  include Contract::Writer

  class_attribute :config, default: {
    disable_custom_interest_payment: true,
    principal_payment_fee_percent: 0.01, # 1%
    activity_reverse_debit_amount: [
      :pawn
    ]
  }

  acts_as_tenant(:branch)

  has_paper_trail

  has_many_attached :files

  belongs_to :customer, optional: true
  belongs_to :branch, optional: true
  belongs_to :contract_type, optional: true, foreign_key: :contract_type_code, primary_key: :code
  belongs_to :asset_setting, optional: true
  belongs_to :cashier, class_name: User.name, foreign_key: :cashier_id, optional: true
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id, optional: true

  has_many :contract_interest_payments, -> { order(:from) }, dependent: :destroy
  has_many :interest_payments, -> { order(:from) }, dependent: :destroy, class_name: ContractInterestPayment.name
  has_many :unpaid_interest_payments, -> { where(payment_status: :unpaid).order(:from) }, class_name: ContractInterestPayment.name, dependent: :destroy
  has_many :paid_interest_payments, -> { where(payment_status: :paid).order(:from) }, class_name: ContractInterestPayment.name, dependent: :destroy
  has_many :financial_transactions, as: :recordable, dependent: :destroy
  has_many :transactions, as: :owner, dependent: :destroy, class_name: FinancialTransaction.name
  has_many :asset_setting_values, dependent: :destroy
  has_many :reminders, dependent: :destroy, class_name: ContractReminder.name

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

  has_many :contract_extensions, -> { order(:from) }, dependent: :destroy
  has_many :activities, -> { order("id DESC") }, class_name: PublicActivity::Activity.name, as: :trackable, dependent: :destroy

  auto_code_config(prefix: "HD", field: :code)
  large_number_field :loan_amount

  enum :status, { active: "active", closed: "closed" }
  enum :contract_type_code, { pawn: "pawn", credit: "credit", installment: "installment", capital: "capital" }

  scope :without_capital, -> { where.not(contract_type_code: ContractType.codes[:capital]) }
  scope :pawn_contracts, -> { where(contract_type_code: ContractType.codes[:pawn]) }
  scope :capital_contracts, -> { where(contract_type_code: ContractType.codes[:capital]) }
  scope :installment_contracts, -> { where(contract_type_code: ContractType.codes[:installment]) }

  accepts_nested_attributes_for :customer,
                                allow_destroy: false,
                                reject_if: :all_blank

  accepts_nested_attributes_for :asset_setting_values,
                                allow_destroy: true,
                                reject_if: :all_blank

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[contract_date]
    end

    def ransackable_associations(auth_object = nil)
      %w[ customer ]
    end
  end
end
