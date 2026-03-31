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
#  transaction_by_id      :uuid
#
class ViewTransactionSummary < ApplicationRecord
  self.table_name = "transaction_summaries"
  self.primary_key = "id"

  belongs_to :branch

  def readonly?
    true
  end

  def pawn?
    transactable_type_code == "pawn"
  end

  def installment?
    transactable_type_code == "installment"
  end

  def income?
    transactable_type_code == "income"
  end

  def expense?
    transactable_type_code == "expense"
  end

  def capital?
    transactable_type_code == "capital"
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[transaction_date transactable_type_code transaction_by_id transaction_by customer_name]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end
end
