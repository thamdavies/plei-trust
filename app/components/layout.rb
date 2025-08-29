# Ref: https://github.com/yippee-fun/phlex-rails/blob/main/lib/phlex/rails/helpers
class Components::Layout < Components::Base
  include Phlex::Rails::Helpers::JavaScriptIncludeTag
  include Phlex::Rails::Helpers::StyleSheetLinkTag

  def initialize(page_info)
    @page_info = page_info
  end

  def view_template
    doctype

    html do
      head do
        title { @page_info.title }
        meta(name: "viewport", content: "width=device-width, initial-scale=1")
        stylesheet_link_tag "application", "data-turbo-track": "reload"
        javascript_include_tag "application", "data-turbo-track": "reload", type: "module"
      end

      body(class: "bg-gray-50 dark:bg-gray-800") do
        render Navigation.new
        div(class: "flex pt-16 overflow-hidden bg-gray-50 dark:bg-gray-900") do
          yield
        end
      end
    end
  end
end