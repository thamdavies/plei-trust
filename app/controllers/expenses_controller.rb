class ExpensesController < ApplicationController
  add_breadcrumb "Quản lý chi tiêu", :expenses_path

  def index
    run(Expense::Operations::Index) do |result|
      @pagy, expenses = pagy(result[:model])
      @expenses = expenses.decorate
      @form = result[:"expense.filter_form"]
    end
  end

  def create
  end

  private

  def permit_params
    params.require(:form).permit(:amount, :party_name, :transaction_type_code, :transaction_note)
  end
end
