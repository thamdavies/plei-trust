class ContractExtensionDecorator < ApplicationDecorator
  delegate_all

  def fm_from_date
    object.from.to_fs(:date_vn)
  end

  def fm_to_date
    object.to.to_fs(:date_vn)
  end
end
