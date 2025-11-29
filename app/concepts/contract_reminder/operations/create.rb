module ContractReminder::Operations
  class Create < ApplicationOperation
    class Reminder
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attr_accessor :date, :note, :contract_id

      def contract
        @contract ||= ::Contract.find(contract_id)
      end
    end

    class Present < ApplicationOperation
      step Model(Reminder, :new)
      step Contract::Build(constant: ::ContractReminder::Contracts::Create)
      step :assign_attributes

      def assign_attributes(ctx, model:, params:, **)
        model.assign_attributes(params)

        ctx[:contract] = model.contract

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Wrap(AppTransaction) {
      step :save
      step :notify
    }

    def save(ctx, model:, params:, **)
      model.contract.reminders.create!(
        reminder_type: ContractReminder.reminder_types[:schedule_reminder],
        date: model.date,
        note: model.note
      )

      true
    end

    def notify(ctx, model:, params:, **)
      ctx[:message] = "Hẹn giờ thành công!"

      true
    end
  end
end
