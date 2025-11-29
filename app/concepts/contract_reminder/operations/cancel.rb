module ContractReminder::Operations
  class Cancel < ApplicationOperation
    class Reminder
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :contract_id

      def contract
        @contract ||= ::Contract.find(contract_id)
      end
    end

    step Model(Reminder, :new)
    step Contract::Build(constant: ::ContractReminder::Contracts::Cancel)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :notify
    }

    def save(ctx, params:, model:, **)
      model.assign_attributes(params)
      ctx[:contract] = model.contract
      ctx[:contract].reminders.create!(
        reminder_type: ContractReminder.reminder_types[:cancel_scheduled_reminder],
      )

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Dừng hẹn giờ thành công!"
      true
    end
  end
end
