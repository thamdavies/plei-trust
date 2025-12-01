class UserDecorator < ApplicationDecorator
  delegate_all

  def fm_created_date
    created_at.to_date.to_fs(:date_vn)
  end
end
