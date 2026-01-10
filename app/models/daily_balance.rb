# == Schema Information
#
# Table name: daily_balances
#
#  id                       :uuid             not null, primary key
#  active_credit_total      :decimal(15, 4)
#  active_installment_total :decimal(15, 4)
#  active_pawn_total        :decimal(15, 4)
#  asset_total              :decimal(15, 4)
#  capital_payable_total    :decimal(15, 4)
#  capital_total            :decimal(15, 4)
#  closing_balance          :decimal(15, 4)
#  credit_total             :decimal(15, 4)
#  date                     :date             not null
#  income_expense_total     :decimal(15, 4)
#  installment_total        :decimal(15, 4)
#  opening_balance          :decimal(15, 4)   default(0.0)
#  pawn_total               :decimal(15, 4)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  branch_id                :uuid             not null
#  created_by_id            :uuid
#
# Indexes
#
#  index_daily_balances_on_branch_id           (branch_id)
#  index_daily_balances_on_branch_id_and_date  (branch_id,date) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#
class DailyBalance < ApplicationRecord
  include LargeNumberFields
  include DailyBalance::Reader

  large_number_field :opening_balance
  large_number_field :closing_balance
  large_number_field :pawn_total
  large_number_field :installment_total
  large_number_field :credit_total
  large_number_field :income_expense_total
  large_number_field :capital_total

  large_number_field :active_pawn_total
  large_number_field :active_credit_total
  large_number_field :active_installment_total
  large_number_field :capital_payable_total
  large_number_field :asset_total

  belongs_to :branch
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id, optional: true

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "date" ]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end
end
