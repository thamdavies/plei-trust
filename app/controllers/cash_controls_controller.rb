class CashControlsController < ApplicationController
  add_breadcrumb "Nhập tiền quỹ đầu ngày", :cash_controls_path

  def index
  end

  def deposit
    ctx = CashControl::Operations::Deposit.call(params: permit_params.to_h)
    if ctx.success?
      flash[:notice] = "Nhập quỹ thành công!"
      redirect_to(asset_settings_path)
    else
      @form = ctx[:"contract.default"]
    end
  end

  def update_opening_balance
  end
end
