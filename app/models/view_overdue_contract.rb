# == Schema Information
#
# Table name: overdue_contracts
#
#  id                          :uuid             primary key
#  asset_name                  :string
#  code                        :string
#  collect_interest_in_advance :boolean
#  contract_date               :date
#  contract_term               :integer
#  interest_calculation_method :string
#  interest_period             :integer
#  interest_rate               :decimal(8, 5)
#  loan_amount                 :decimal(15, 2)
#  note                        :text
#  status                      :string
#  created_at                  :datetime
#  updated_at                  :datetime
#  asset_setting_id            :uuid
#  branch_id                   :uuid
#  cashier_id                  :uuid
#  contract_type_id            :uuid
#  created_by_id               :uuid
#  customer_id                 :uuid
#
class ViewOverdueContract < Contract
  self.table_name = "overdue_contracts"

  def readonly?
    true
  end
end
