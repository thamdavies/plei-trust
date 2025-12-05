class Contracts::DebtsController < ContractsController
  before_action :set_contract, only: [ :create, :destroy ]

  def create
    authorize @contract, :update?

    ctx = Debt::Operations::Create.call(params: debt_params.to_h, current_user:, current_branch:)

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

    ctx = Debt::Operations::Destroy.call(params: debt_params.to_h, current_user:, current_branch:)

    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx[:"contract.default"]
    end

    @contract = ctx[:model].contract.decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
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

  def contract_id
    debt_params[:contract_id]
  end
end
