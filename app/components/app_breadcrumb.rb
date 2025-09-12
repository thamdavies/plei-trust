class Components::AppBreadcrumb < Components::Base
  def initialize(breadcrumbs = [])
    @breadcrumbs = breadcrumbs
  end

  def view_template
    Breadcrumb(class: "mb-2") do
      BreadcrumbList do
        BreadcrumbItem do
          BreadcrumbLink(href: "/") { "Trang chủ" }
        end
        @breadcrumbs.each_with_index do |breadcrumb, index|
          BreadcrumbSeparator()
          BreadcrumbItem do
            if index == @breadcrumbs.size - 1
              BreadcrumbPage { breadcrumb.name }
            else
              BreadcrumbLink(href: send(breadcrumb.path)) { breadcrumb.name }
            end
          end
        end
      end
    end
  end
end
