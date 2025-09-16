# == Schema Information
#
# Table name: contract_interest_payments
#
#  id              :uuid             not null, primary key
#  amount          :decimal(15, 2)
#  from            :date
#  notes           :text
#  number_of_days  :integer
#  other_amount    :decimal(15, 2)
#  payment_status  :string           default("unpaid")
#  status          :string
#  to              :date
#  total_amount    :decimal(15, 2)
#  total_paid      :decimal(15, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contract_id     :uuid             not null
#  processed_by_id :uuid             not null
#
# Indexes
#
#  index_contract_interest_payments_on_contract_id      (contract_id)
#  index_contract_interest_payments_on_processed_by_id  (processed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (processed_by_id => users.id)
#
require "test_helper"

class ContractInterestPaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
