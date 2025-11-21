class Pdfs::InterestPaymentsController < ContractsController
  layout "blank"

  def show
    ctx = ContractInterestPayment::Operations::BillPrinter.call(params: print_params.to_h, current_user:)
    @contract = ctx[:contract]
    @customer = ctx[:customer]
    @interest_payment = ctx[:model].decorate
    @next_period = ctx[:next_period]
  end

  private

  def print_params
    params.permit(:id, :contract_id)
  end
end
