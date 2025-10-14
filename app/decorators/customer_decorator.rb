class CustomerDecorator < ApplicationDecorator
  delegate_all

  def fm_old_debt_amount
    object.old_debt_amount.to_f.to_currency
  end
end
