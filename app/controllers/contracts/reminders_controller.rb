class Contracts::RemindersController < ContractsController
  def create
    ctx = ContractReminder::Operations::Create.call(params: create_params.to_h, current_user:)

    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:model].contract.decorate
  end

  def destroy
    ctx = ContractReminder::Operations::Cancel.call(params: cancel_params.to_h, current_user:)

    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:contract].decorate
  end

  private

  def create_params
    params.require(:form).permit(:date, :note, :contract_id)
  end

  def cancel_params
    params.require(:form).permit(:contract_id)
  end
end
