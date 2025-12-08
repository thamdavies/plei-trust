class PublicActivity::ActivityDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def fm_created_at
    object.created_at.to_date.to_fs(:date_vn)
  end

  def fm_activity_key
    I18n.t(key)
  end

  def owner_name
    object.owner&.full_name || "Hệ thống"
  end

  def fm_debit_amount
    (object.parameters[:debit_amount].to_d * 1_000).to_currency(unit: "")
  end

  def fm_credit_amount
    (object.parameters[:credit_amount].to_d * 1_000).to_currency(unit: "")
  end

  def fm_other_amount
    (object.parameters[:other_amount].to_d * 1_000).to_currency(unit: "")
  end

  def fm_amount
    (object.parameters[:amount].to_d * 1_000).to_currency(unit: "")
  end

  def fm_note
    object.parameters[:note].to_s
  end
end
