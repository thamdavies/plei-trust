# == Schema Information
#
# Table name: financial_transactions
#
#  id                  :string(27)       not null, primary key
#  amount              :decimal(15, 2)   not null
#  description         :string
#  reference_number    :string
#  transaction_date    :date             not null
#  transaction_number  :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contract_id         :string           not null
#  created_by_id       :string           not null
#  transaction_type_id :string           not null
#
# Indexes
#
#  index_financial_transactions_on_contract_id          (contract_id)
#  index_financial_transactions_on_created_by_id        (created_by_id)
#  index_financial_transactions_on_transaction_type_id  (transaction_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (transaction_type_id => transaction_types.id)
#
require "test_helper"

class FinancialTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
