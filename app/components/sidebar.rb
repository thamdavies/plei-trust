# frozen_string_literal: true

class Components::Sidebar < Components::Base
  def view_template
    aside(
      id: "sidebar",
      class: "fixed top-0 left-0 z-20 flex flex-col flex-shrink-0 hidden w-64 h-full pt-16 font-normal duration-75 lg:flex transition-width",
      aria_label: "Sidebar",
      data_app_target: "sidebar"
    ) do
      div(class: "relative flex flex-col flex-1 min-h-0 pt-0 bg-white border-r border-gray-200 dark:bg-gray-800 dark:border-gray-700") do
        div(class: "flex flex-col flex-1 pt-5 pb-4 overflow-y-auto") do
          div(class: "flex-1 px-3 space-y-1 bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700") do
            ul(class: "pb-2 space-y-2") do
              li do
                # form(action: "#", method: "GET", class: "lg:hidden") do
                #   label(for: "mobile-search", class: "sr-only") { "Search" }
                #   div(class: "relative") do
                #     div(class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
                #       Remix::SearchLine(class: "w-5 h-5 text-gray-500")
                #     end
                #     input(type: "text", name: "email", id: "mobile-search", class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-gray-200 dark:focus:ring-primary-500 dark:focus:border-primary-500", placeholder: "Search")
                #   end
                # end
              end
              li do
                Link(href: "/", variant: :sidebar, class: view_context.active_link_class(root_path)) do
                  Remix::HomeLine(class: "w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white")
                  span(class: "flex-1 ml-3 text-left whitespace-nowrap", sidebar_toggle_item: "") { I18n.t("sidebar.dashboard") }
                end
              end

              li do
                Button(
                  variant: :sidebar,
                  arial_controls: "dropdown-layouts",
                  data_collapse_toggle: "dropdown-layouts",
                  aria_expanded: "false") do
                  Remix::ContractLine(class: "flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white")
                  span(class: "flex-1 ml-3 text-left whitespace-nowrap", sidebar_toggle_item: "") { I18n.t("sidebar.contract") }
                  Remix::ArrowDownSLine(class: "w-6 h-6")
                end

                ul(id: "dropdown-layouts", class: "py-2 space-y-2 hidden") do
                  li do
                    Link(href: "/", variant: :sidebar_item) do
                      span(class: "text-left whitespace-nowrap") { I18n.t("sidebar.all_contracts") }
                    end
                  end
                end
              end

              li do
                Link(href: customers_path, variant: :sidebar, class: view_context.active_link_class(customers_path)) do
                  Remix::UserLine(class: "w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white")
                  span(class: "flex-1 ml-3 text-left whitespace-nowrap", sidebar_toggle_item: "") { I18n.t("sidebar.customer") }
                end
              end
            end
            # ...existing code for sidebar bottom menu and other sections...
          end
        end
      end
    end
  end
end
