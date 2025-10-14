class Contracts::InterestPaymentsController < ApplicationController
  def update
    ctx = ContractInterestPayment::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      flash.now[:alert] = ctx["contract.default"].errors[:id].first
    end

    @contract = ctx[:model].contract.decorate
  end

  def permit_params
    params.require(:form).permit(:id, :total_paid, :contract_id)
  end
end
