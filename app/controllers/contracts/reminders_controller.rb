class Contracts::RemindersController < ContractsController
  before_action :set_contract, only: [ :create, :destroy ]

  def index
    run(ContractReminder::Operations::Index, current_branch:) do |result|
      reminders = result[:active_reminders].decorate
      @pagy, @reminders = pagy(reminders)
    end
  end

  def create
    authorize @contract, :update?

    ctx = ContractReminder::Operations::Create.call(params: create_params.to_h, current_user:)

    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:model].contract.decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  def destroy
    authorize @contract, :update?

    ctx = ContractReminder::Operations::Cancel.call(params: cancel_params.to_h, current_user:)

    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:contract].decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  private

  def create_params
    params.require(:form).permit(:date, :note, :contract_id)
  end

  def cancel_params
    params.require(:form).permit(:contract_id)
  end

  def contract_id
    params[:form][:contract_id]
  end
end
