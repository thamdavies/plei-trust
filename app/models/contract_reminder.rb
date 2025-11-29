# == Schema Information
#
# Table name: contract_reminders
#
#  id            :uuid             not null, primary key
#  date          :datetime
#  note          :text
#  reminder_type :string           not null
#  status        :string           default("active")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contract_id   :uuid             not null
#
# Indexes
#
#  index_contract_reminders_on_contract_id  (contract_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#
class ContractReminder < ApplicationRecord
  belongs_to :contract

  enum :reminder_type, {
    schedule_reminder: "schedule_reminder",
    cancel_scheduled_reminder: "cancel_scheduled_reminder"
  }

  enum :status, { active: "active", canceled: "canceled" }
end
