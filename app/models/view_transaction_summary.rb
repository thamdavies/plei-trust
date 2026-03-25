# == Schema Information
#
# Table name: transaction_summaries
#
#  activity_key       :string
#  asset_name         :string
#  contract_code      :string
#  contract_type_name :string
#  customer_name      :string
#  description        :text
#  notes              :text
#  source_type        :string
#  transaction_by     :string
#  transaction_date   :date
#  created_at         :datetime
#  branch_id          :uuid
#
class ViewTransactionSummary < ApplicationRecord
  self.table_name = "transaction_summaries"

  belongs_to :branch

  def readonly?
    true
  end

  def transaction_date
    super&.to_fs(:date_vn)
  end

  def description
    return I18n.t(activity_key) if source_type == "activity"

    super
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
      %w[branch_id transaction_date contract_type_name transaction_by customer_name]
    end
  end
end
