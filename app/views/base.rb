# frozen_string_literal: true

class Views::Base < Components::Base
  # Lấy CSRF token thông qua view helpers
  def form_authenticity_token
    view_context.form_authenticity_token
  end
end
