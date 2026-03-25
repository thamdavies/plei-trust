# == Schema Information
#
# Table name: transaction_summaries
#
#  id                     :uuid             primary key
#  asset_name             :string
#  contract_code          :string
#  customer_name          :string
#  description            :string
#  notes                  :text
#  raw_credit_amount      :decimal(, )
#  raw_debit_amount       :decimal(, )
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

  def transaction_date
    super&.to_fs(:date_vn)
  end

  def amount_in
    return "0" if raw_debit_amount.blank? || raw_debit_amount.zero?

    (raw_debit_amount * 1_000).to_currency(unit: "")
  end

  def amount_out
    return "0" if raw_credit_amount.blank? || raw_credit_amount.zero?

    (raw_credit_amount * 1_000).to_currency(unit: "")
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[branch_id transaction_date contract_type_name transaction_by customer_name description]
    end
  end
end
