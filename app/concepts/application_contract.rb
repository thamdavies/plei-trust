# frozen_string_literal: true

class ApplicationContract < Reform::Form
  feature Reform::Form::Dry

  def valid_date?(date_string)
    Date.strptime(date_string, "%Y-%m-%d")

    true
  rescue ArgumentError
    false
  end
end
