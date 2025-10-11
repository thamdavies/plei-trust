class Contracts::CustomInterestPaymentsController < ApplicationController
  def create
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
end
