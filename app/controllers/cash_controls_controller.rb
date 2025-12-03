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

  #  id                  :uuid             not null, primary key
  #  amount              :decimal(15, 4)   not null
  #  description         :string
  #  party_name          :string
  #  recordable_type     :string           not null
  #  reference_number    :string
  #  transaction_date    :date             not null
  #  transaction_number  :string           not null
  #  created_at          :datetime         not null
  #  updated_at          :datetime         not null
  #  created_by_id       :uuid             not null
  #  recordable_id       :uuid             not null
  #  transaction_type_id :uuid             not null
  def deposit_params
    params.require(:form).permit(:amount)
  end

  def update_opening_balance_params
    params.require(:form).permit(:amount)
  end
end
