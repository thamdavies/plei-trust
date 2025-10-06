# == Schema Information
#
# Table name: contract_extensions
#
#  id             :uuid             not null, primary key
#  content        :text
#  from           :date
#  note           :text
#  number_of_days :integer
#  to             :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contract_id    :uuid             not null
#
# Indexes
#
#  index_contract_extensions_on_contract_id  (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class ContractExtension < ApplicationRecord
  belongs_to :contract
end
