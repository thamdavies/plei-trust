class InterestCalculationMethodsController < ApplicationController
  def show
    @interest_calculation_method = InterestCalculationMethod.find_by!(code: params[:id])
    render json: @interest_calculation_method
  end
end
