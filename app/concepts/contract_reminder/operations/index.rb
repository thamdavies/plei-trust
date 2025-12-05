module ContractReminder::Operations
  class Index < ApplicationOperation
    step :load_reminders

    def load_reminders(ctx, current_branch:, params:, **)
      ctx[:active_reminders] = current_branch.reminders.includes(contract: :customer).ransack(params[:q]).result

      true
    end
  end
end
