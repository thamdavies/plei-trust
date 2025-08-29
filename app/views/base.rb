# frozen_string_literal: true

class Views::Base < Components::Base
  # The `Views::Base` is an abstract class for all your views.

  # By default, it inherits from `Components::Base`, but you
  # can change that to `Phlex::HTML` if you want to keep views and
  # components independent.

  include Components
  include PhlexIcons

  PageInfo = Data.define(:title)

  def around_template
    render template_layout.new(page_info) do
      super
    end
  end

  def template_layout
    if defined?(layout)
      layout
    else
      Components::Layout
    end
  end

  def page_info
    PageInfo.new(
      title: page_title
    )
  end
end
