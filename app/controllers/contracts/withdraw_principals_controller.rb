class Contracts::WithdrawPrincipalsController < ApplicationController
  def update
    ctx = WithdrawPrincipal::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
  end

  def show
    ctx = WithdrawPrincipal::Operations::Show.call(params: show_params.to_h, current_user:)
    render json: ctx[:withdraw_principal]
  end

  private

  def permit_params
    params.require(:form).permit(:contract_id, :transaction_date, :withdrawal_amount, :other_amount, :note)
  end

  def show_params
    params.permit(:transaction_date, :other_amount, :id).merge(contract_id: params[:id])
  end
end
