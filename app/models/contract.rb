# == Schema Information
#
# Table name: contracts
#
#  id                          :uuid             not null, primary key
#  asset_name                  :string
#  code                        :string
#  collect_interest_in_advance :boolean          default(FALSE)
#  contract_date               :date
#  contract_term               :integer
#  interest_calculation_method :string
#  interest_period             :integer
#  interest_rate               :decimal(8, 5)
#  loan_amount                 :decimal(15, 2)
#  note                        :text
#  status                      :string           default("active")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  asset_setting_id            :uuid
#  branch_id                   :uuid             not null
#  cashier_id                  :uuid             not null
#  contract_type_id            :uuid             not null
#  created_by_id               :uuid             not null
#  customer_id                 :uuid             not null
#
# Indexes
#
#  index_contracts_on_asset_setting_id  (asset_setting_id)
#  index_contracts_on_branch_id         (branch_id)
#  index_contracts_on_cashier_id        (cashier_id)
#  index_contracts_on_contract_type_id  (contract_type_id)
#  index_contracts_on_created_by_id     (created_by_id)
#  index_contracts_on_customer_id       (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (asset_setting_id => asset_settings.id)
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (cashier_id => users.id)
#  fk_rails_...  (contract_type_id => contract_types.id)
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
    principal_payment_fee_percent: 0.01 # 1%
  }

  acts_as_tenant(:branch)

  has_paper_trail

  belongs_to :customer, optional: true
  belongs_to :branch, optional: true
  belongs_to :contract_type, optional: true
  belongs_to :asset_setting, optional: true
  belongs_to :cashier, class_name: User.name, foreign_key: :cashier_id, optional: true
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id, optional: true

  has_many :contract_interest_payments, -> { order(:from) }, dependent: :destroy
  has_many :interest_payments, -> { order(:from) }, dependent: :destroy, class_name: ContractInterestPayment.name
  has_many :unpaid_interest_payments, -> { where(payment_status: :unpaid).order(:from) }, class_name: ContractInterestPayment.name, dependent: :destroy
  has_many :paid_interest_payments, -> { where(payment_status: :paid).order(:from) }, class_name: ContractInterestPayment.name, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy

  has_many :reduce_principals, -> { where(transaction_type: TransactionType.reduce_principal).order(:transaction_date) }, class_name: FinancialTransaction.name, foreign_key: :contract_id, dependent: :destroy
  has_many :additional_loans, -> { where(transaction_type: TransactionType.additional_loan).order(:transaction_date) }, class_name: FinancialTransaction.name, foreign_key: :contract_id, dependent: :destroy
  has_many :withdrawal_principals, -> { where(transaction_type: TransactionType.withdrawal_principal).order(:transaction_date) }, class_name: FinancialTransaction.name, foreign_key: :contract_id, dependent: :destroy
  has_many :contract_extensions, -> { order(:from) }, dependent: :destroy
  has_many :activities, -> { order("id DESC") }, class_name: PublicActivity::Activity.name, as: :trackable, dependent: :destroy

  auto_code_config(prefix: "HD", field: :code)
  large_number_field :loan_amount

  enum :status, { active: "active", closed: "closed" }

  scope :capital_contracts, -> { where(contract_type: { code: :capital }) }

  accepts_nested_attributes_for :customer,
                                allow_destroy: false,
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
