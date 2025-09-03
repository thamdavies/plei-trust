# == Schema Information
#
# Table name: transaction_types
#
#  id          :string(27)       not null, primary key
#  code        :string
#  description :text
#  is_income   :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TransactionType < ApplicationRecord
end
