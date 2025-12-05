class ContractReminderDecorator < ApplicationDecorator
  delegate_all

  def fm_remind_date
    date.to_date.to_fs(:date_vn) if date.present?
  end

  def fm_created_at
    created_at.to_date.to_fs(:date_vn) if created_at.present?
  end

  def fm_state
    I18n.t("contract_reminder.states.#{reminder_type}")
  end

  def customer_name
    contract.customer.full_name
  end

  def contract_type_name
    contract.contract_type.name
  end
end
