# == Schema Information
#
# Table name: contract_interest_payments
#
#  id              :uuid             not null, primary key
#  amount          :decimal(15, 2)
#  from            :date
#  note            :text
#  number_of_days  :integer
#  other_amount    :decimal(15, 2)
#  payment_status  :string           default("unpaid")
#  to              :date
#  total_amount    :decimal(15, 2)
#  total_paid      :decimal(15, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contract_id     :uuid             not null
#
# Indexes
#
#  index_contract_interest_payments_on_contract_id      (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class ContractInterestPayment < ApplicationRecord
  include LargeNumberFields

  belongs_to :contract

  enum :payment_status, { unpaid: "unpaid", paid: "paid", partial: "partial" }

  large_number_field :amount
end
