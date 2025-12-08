class CashControlsController < ApplicationController
  add_breadcrumb "Nhập tiền quỹ đầu ngày", :cash_controls_path

  def index
    run(CashControl::Operations::Index, current_branch:) do |result|
      @summary = result[:summary]
      @transactions = result[:transactions].decorate
    end
  end

  def deposit
    ctx = CashControl::Operations::Deposit.call(params: deposit_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash[:notice] = "Nhập quỹ thành công!"
      redirect_to(cash_controls_path)
    else
      @form = ctx[:"contract.default"]
    end
  end

  def update_opening_balance
    ctx = CashControl::Operations::UpdateOpeningBalance.call(params: update_opening_balance_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash[:notice] = "Nhập tiền đầu ngày thành công!"
      redirect_to(cash_controls_path)
    else
      @form = ctx[:"contract.default"]
    end
  end

  private

  def deposit_params
    params.require(:form).permit(:amount).merge(daily_balance: daily_balance)
  end

  def update_opening_balance_params
    params.require(:form).permit(:amount).merge(daily_balance: daily_balance)
  end
end
