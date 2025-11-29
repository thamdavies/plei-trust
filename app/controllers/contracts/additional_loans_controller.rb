class Contracts::AdditionalLoansController < ContractsController
  before_action :set_contract, only: [ :update, :destroy ]

  def update
    authorize @contract, :update?

    ctx = AdditionalLoan::Operations::Update.call(params: permit_params.to_h, current_user:)
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

    ctx = AdditionalLoan::Operations::Cancel.call(params: cancel_params.to_h, current_user:)
    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      err_msg = ctx["contract.default"].errors.messages[:id].first || "Đã có lỗi xảy ra khi hủy vay thêm"
      flash.now[:error] = err_msg
    end

    @contract = ctx[:contract].decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  private

  def permit_params
    params.require(:form).permit(:contract_id, :transaction_date, :transaction_amount, :note)
  end

  def cancel_params
    params.require(:form).permit(:contract_id).merge(id: params[:id])
  end

  def contract_id
    permit_params[:contract_id]
  end
end
