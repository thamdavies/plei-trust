# == Schema Information
#
# Table name: contract_types
#
#  id          :string(27)       not null, primary key
#  code        :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ContractType < ApplicationRecord
end
