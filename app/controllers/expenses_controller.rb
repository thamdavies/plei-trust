class ExpensesController < ApplicationController
  add_breadcrumb "Quản lý chi tiêu", :expenses_path

  def index
    run(Expense::Operations::Index, current_branch:) do |result|
      @pagy, expenses = pagy(result[:model])
      @expenses = expenses.decorate
    end

    run(Expense::Operations::Create::Present, params: build_params) do |result|
      @form = result[:"contract.default"]
    end
  end

  def create
    ctx = Expense::Operations::Create.call(params: permit_params.to_h, current_branch:, current_user:)
    if ctx.success?
      flash[:success] = ctx[:message]
      redirect_to(expenses_path)
    else
      @form = ctx[:"contract.default"]
    end
  end

  private

  def build_params
    {
      amount: 0
    }
  end

  def permit_params
    params.require(:form).permit(:amount, :party_name, :transaction_type_code, :transaction_note)
  end
end
