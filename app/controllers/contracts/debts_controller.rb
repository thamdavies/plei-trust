class Contracts::DebtsController < ContractsController
  def create
    ctx = Debt::Operations::Create.call(params: debt_params.to_h, current_user:)

    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:model].contract.decorate
  end

  def destroy
    ctx = Debt::Operations::Destroy.call(params: debt_params.to_h, current_user:)

    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:model].contract.decorate
  end

  private

  def debt_params
    @debt_params ||= begin
      if params[:id].present?
        params.require(:form).permit(:amount, :contract_id).merge(contract_id: params[:id])
      else
        params.require(:form).permit(:amount, :contract_id)
      end
    end
  end
end
