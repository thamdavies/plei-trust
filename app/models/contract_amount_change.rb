# == Schema Information
#
# Table name: contract_amount_changes
#
#  id              :uuid             not null, primary key
#  action_date     :date
#  amount          :decimal(15, 4)
#  note            :text
#  type            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contract_id     :uuid             not null
#  processed_by_id :uuid             not null
#
# Indexes
#
#  index_contract_amount_changes_on_contract_id      (contract_id)
#  index_contract_amount_changes_on_processed_by_id  (processed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (processed_by_id => users.id)
#
class ContractAmountChange < ApplicationRecord
  belongs_to :contract
end
