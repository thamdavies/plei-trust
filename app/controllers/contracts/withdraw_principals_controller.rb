class Contracts::WithdrawPrincipalsController < ContractsController
  before_action :set_contract, only: [ :update ]

  def update
    authorize @contract, :update?

    ctx = WithdrawPrincipal::Operations::Update.call(params: permit_params.to_h, current_user:)

    if ctx.success?
      flash.now[:success] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  def show
    ctx = WithdrawPrincipal::Operations::Show.call(params: show_params.to_h, current_user:)
    render json: ctx[:withdraw_principal]
  end

  private

  def contract_id
    permit_params[:contract_id]
  end

  def permit_params
    params.require(:form)
          .permit(:contract_id, :transaction_date, :withdrawal_amount, :other_amount, :note)
          .merge(start_date:)
  end

  def show_params
    params.permit(:transaction_date, :other_amount, :id).merge(contract_id: params[:id], start_date:)
  end

  def start_date
    @start_date ||= begin
      contract = Contract.find(params[:id])
      if contract.no_interest?
        contract.contract_date
      else
        ContractInterestPayment.unpaid.where(contract_id: params[:id]).order(:from).first&.from || Date.current
      end
    end
  end
end
