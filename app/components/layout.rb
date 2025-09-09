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
        link(rel: "icon", type: "image/png", href: "/favicon-96x96.png", sizes: "96x96")
        link(rel: "icon", type: "image/svg+xml", href: "/favicon.svg")
        link(rel: "shortcut icon", href: "/favicon.ico")
        link(rel: "apple-touch-icon", sizes: "180x180", href: "/apple-touch-icon.png")
        link(rel: "manifest", href: "/site.webmanifest")
        stylesheet_link_tag "application", "data-turbo-track": "reload", preload: true, as: "style"
        javascript_include_tag "application", "data-turbo-track": "reload", type: "module"
      end

      body(class: "bg-gray-50 dark:bg-gray-800", data_controller: "app") do
        render Navigation.new
        div(class: "flex pt-16 overflow-hidden bg-gray-50 dark:bg-gray-900") do
          render Sidebar.new
          div(class: "fixed inset-0 z-10 hidden bg-gray-900/50 dark:bg-gray-900/90", data_app_target: "sidebarBackdrop")
          div(id: "main-content", class: "relative w-full overflow-y-auto bg-gray-50 lg:ml-64 dark:bg-gray-800") do
            main do
              div(class: "p-4 bg-white block sm:flex items-center justify-between border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700") do
                div(class: "w-full mb-1") do
                  div(class: "mb-4") do
                    nav(class: "flex mb-5") do
                      Breadcrumb do
                        BreadcrumbList do
                          @page_info.breadcrumbs.each_with_index do |breadcrumb, index|
                            BreadcrumbItem do
                              if index != @page_info.breadcrumbs.size - 1
                                BreadcrumbLink(href: breadcrumb[:path]) { breadcrumb[:title] }
                              else
                                BreadcrumbPage { breadcrumb[:title] }
                              end
                            end
                            BreadcrumbSeparator() unless index == @page_info.breadcrumbs.size - 1
                          end
                        end
                      end
                    end if @page_info.breadcrumbs.any?

                    h1(class: "text-xl font-semibold text-gray-900 sm:text-xl dark:text-white") do
                      @page_info.subtitle
                    end
                  end

                  div(class: "sm:flex justify-between") do
                    render(FilterForm.new(@page_info.filter_form))
                  end
                end
              end

              yield
            end
          end
        end
      end
    end
  end
end
