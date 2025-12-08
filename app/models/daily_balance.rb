# == Schema Information
#
# Table name: daily_balances
#
#  id              :uuid             not null, primary key
#  closing_balance :decimal(15, 4)
#  date            :date             not null
#  opening_balance :decimal(15, 4)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  branch_id       :uuid             not null
#  created_by_id   :uuid
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

  large_number_field :opening_balance
  large_number_field :closing_balance

  belongs_to :branch
  belongs_to :created_by, class_name: User.name, foreign_key: :created_by_id, optional: true
end
