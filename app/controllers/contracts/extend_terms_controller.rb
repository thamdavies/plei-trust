class Contracts::ExtendTermsController < ContractsController
  before_action :set_contract, only: [ :update ]

  def update
    authorize @contract, :update?

    ctx = ExtendTerm::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
  end

  private

  def contract_id
    permit_params[:contract_id]
  end

  def permit_params
    params.require(:form).permit(:contract_id, :number_of_days, :note)
  end
end
