# == Schema Information
#
# Table name: contract_terminations
#
#  id               :uuid             not null, primary key
#  amount           :decimal(15, 2)
#  interest_amount  :decimal(15, 2)
#  old_debt         :decimal(15, 2)
#  other_amount     :decimal(15, 2)
#  termination_date :date
#  total_amount     :decimal(15, 2)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  contract_id      :uuid             not null
#  processed_by_id  :uuid             not null
#
# Indexes
#
#  index_contract_terminations_on_contract_id      (contract_id)
#  index_contract_terminations_on_processed_by_id  (processed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (processed_by_id => users.id)
#
class ContractTermination < ApplicationRecord
  belongs_to :contract
end
