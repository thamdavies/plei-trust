class IncomesController < ApplicationController
  add_breadcrumb "Quản lý thu nhập", :incomes_path

  def index
    run(Income::Operations::Index, current_branch:) do |result|
      @pagy, incomes = pagy(result[:model])
      @incomes = incomes.decorate
    end

    run(Income::Operations::Create::Present, params: build_params) do |result|
      @form = result[:"contract.default"]
    end
  end

  def create
    ctx = Income::Operations::Create.call(params: permit_params.to_h, current_branch:, current_user:)
    if ctx.success?
      flash[:success] = ctx[:message]
      redirect_to(incomes_path)
    else
      @form = ctx[:"contract.default"]
    end
  end

  def destroy
  income = current_branch.financial_transactions.find(params[:id])
    income.destroy!

    flash[:success] = "Xóa phiếu thu thành công!"
    redirect_to(incomes_path)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Phiếu thu không tồn tại hoặc đã bị xóa."
    redirect_to(incomes_path)
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
