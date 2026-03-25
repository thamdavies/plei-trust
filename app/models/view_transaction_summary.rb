# == Schema Information
#
# Table name: transaction_summaries
#
#  id                     :uuid             primary key
#  amount_in              :decimal(, )
#  amount_out             :decimal(, )
#  asset_name             :string
#  contract_code          :string
#  customer_name          :string
#  description            :string
#  notes                  :text
#  transactable_type_code :string
#  transaction_by         :string
#  transaction_date       :date
#  created_at             :datetime
#  branch_id              :uuid
#
class ViewTransactionSummary < ApplicationRecord
  self.table_name = "transaction_summaries"
  self.primary_key = "id"

  belongs_to :branch

  def readonly?
    true
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[branch_id transaction_date contract_type_name transaction_by customer_name description]
    end
  end
end
