class Contracts::InterestPaymentsController < ContractsController
  before_action :set_contract, only: [ :update ]

  def update
    authorize @contract, :update?

    ctx = ContractInterestPayment::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      flash.now[:alert] = ctx["contract.default"].errors[:id].first
    end

    @contract = ctx[:model].contract.decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  private

  def contract_id
    permit_params[:contract_id]
  end

  def permit_params
    @permit_params ||= params.require(:form).permit(:id, :total_paid, :contract_id)
  end
end
