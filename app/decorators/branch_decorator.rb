class BranchDecorator < ApplicationDecorator
  delegate_all

  def full_address
    if address.blank?
      [ ward&.name, province&.name ].compact.join(", ")
    else
      [ address, ward&.name, province&.name ].compact.join(", ")
    end
  end
end
