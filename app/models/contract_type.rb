# == Schema Information
#
# Table name: contract_types
#
#  id          :uuid             not null, primary key
#  code        :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ContractType < ApplicationRecord
  enum :code, { pawn: "pawn", credit: "credit", installment: "installment", capital: "capital" }

  scope :with_assets, -> { where(code: %i[pawn credit]) }
end
