class Contracts::ReducePrincipalsController < ContractsController
  before_action :set_contract, only: [ :update, :destroy ]

  def update
    authorize @contract, :update?

    ctx = ReducePrincipal::Operations::Update.call(params: permit_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  def destroy
    authorize @contract, :update?

    ctx = ReducePrincipal::Operations::Cancel.call(params: cancel_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      err_msg = ctx["contract.default"].errors.messages[:id].first || "Đã có lỗi xảy ra khi hủy rút bớt gốc"
      flash.now[:error] = err_msg
    end

    @contract = ctx[:contract].decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  private

  def contract_id
    permit_params[:contract_id]
  end

  def permit_params
    params.require(:form).permit(:contract_id, :prepayment_date, :prepayment_amount, :note)
  end

  def cancel_params
    params.require(:form).permit(:contract_id).merge(id: params[:id])
  end
end
