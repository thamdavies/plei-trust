class Components::Layout < Components::Base
  def initialize(page_info)
    @page_info = page_info
  end

  def view_template
    doctype

    html do
      head do
        title { @page_info.title }
        meta(name: "viewport", content: "width=device-width, initial-scale=1")
      end

      body(class: "bg-gray-50 dark:bg-gray-800") do
        main(class: "pt-20") do
          yield
        end
      end
    end
  end
end