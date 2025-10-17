class Contracts::ReducePrincipalsController < ApplicationController
  def update
    ctx = ReducePrincipal::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
    @tab = "reduce_principal"
  end

  def destroy
    ctx = ReducePrincipal::Operations::Cancel.call(id: params[:id], current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
    @tab = "reduce_principal"
  end

  private

  def permit_params
    params.require(:form).permit(:contract_id, :prepayment_date, :prepayment_amount, :note)
  end
end
