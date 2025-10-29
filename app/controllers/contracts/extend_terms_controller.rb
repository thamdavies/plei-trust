class Contracts::ExtendTermsController < ApplicationController
  def update
    ctx = ExtendTerm::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
  end

  private

  def permit_params
    params.require(:form).permit(:contract_id, :number_of_days, :note)
  end
end
