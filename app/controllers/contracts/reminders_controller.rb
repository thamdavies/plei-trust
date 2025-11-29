class Contracts::RemindersController < ContractsController
  def create
    ctx = ContractReminder::Operations::Create.call(params: permit_params.to_h, current_user:)

    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:model].contract.decorate
  end

  private

  def permit_params
    params.require(:form).permit(:date, :note, :contract_id)
  end
end
