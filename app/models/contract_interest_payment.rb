# == Schema Information
#
# Table name: contract_interest_payments
#
#  id             :uuid             not null, primary key
#  amount         :decimal(15, 2)   default(0.0)
#  custom_payment :boolean          default(FALSE)
#  from           :date
#  note           :text
#  number_of_days :integer
#  other_amount   :decimal(15, 2)   default(0.0)
#  paid_at        :datetime
#  payment_status :string           default("unpaid")
#  to             :date
#  total_amount   :decimal(15, 2)   default(0.0)
#  total_paid     :decimal(15, 2)   default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contract_id    :uuid             not null
#
# Indexes
#
#  index_contract_interest_payments_on_contract_id  (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class ContractInterestPayment < ApplicationRecord
  include LargeNumberFields
  include ContractInterestPayment::Reader

  belongs_to :contract

  enum :payment_status, { unpaid: "unpaid", paid: "paid" }

  large_number_field :amount
  large_number_field :other_amount
  large_number_field :total_amount
  large_number_field :total_paid

  scope :start_date_less_than, ->(date) { where(arel_table[:from].lt(date)) }
  scope :start_date_greater_than, ->(date) { where(arel_table[:from].gt(date)) }
  scope :due_date_less_than, ->(date) { where(arel_table[:to].lt(date)) }
  scope :due_date_greater_than, ->(date) { where(arel_table[:to].gt(date)) }

  scope :custom_payments, -> { where(custom_payment: true) }
end
