class Contracts::CustomInterestPaymentsController < ApplicationController
  def create
    ctx = CustomInterestPayment::Operations::Create.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash[:notice] = "Đóng lãi thành công"
      @contract = ctx[:contract].decorate
    else
      @form = ctx[:"contract.default"]
    end
  end

  def show
    run(CustomInterestPayment::Operations::Show, params: params.permit(:id, :from_date, :to_date)) do |result|
      if result.success?
        render json: result[:custom_interest_payment]
      else
        render json: { errors: result["contract.default"].errors.to_h }, status: :unprocessable_entity
      end
    end
  end

  def permit_params
    params.require(:form).permit(
      :contract_id,
      :from_date,
      :to_date,
      :days_count,
      :interest_amount,
      :other_amount,
      :total_interest_amount,
      :customer_payment_amount,
      :note
    )
  end
end
