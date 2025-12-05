# frozen_string_literal: true

class Components::Navigation < Components::Base
  def initialize(current_user:)
    @current_user = current_user
  end

  def view_template
    nav(class: "fixed z-30 w-full bg-white border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700") do
      div(class: "px-3 py-3 lg:px-5 lg:pl-3") do
        div(class: "flex items-center justify-between") do
          div(class: "flex items-center justify-start") do
            button(
              id: "toggleSidebarMobile",
              aria_expanded: "true",
              aria_controls: "sidebar",
              class: "p-2 text-gray-600 rounded cursor-pointer lg:hidden hover:text-gray-900 hover:bg-gray-100 focus:bg-gray-100 dark:focus:bg-gray-700 focus:ring-2 focus:ring-gray-100 dark:focus:ring-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
            ) do
              Remix::MenuLine(data_app_target: "toggleSidebarMobileHamburger", data_action: "click->app#toggleSidebarMobile", class: "w-6 h-6")
              Remix::CloseLine(data_app_target: "toggleSidebarMobileClose", data_action: "click->app#toggleSidebarMobile", class: "hidden w-6 h-6")
            end
            a(href: "/", class: "flex ml-2 md:mr-24 justify-center") do
              image_tag("logo.png", class: "h-8 mr-3", alt: "PleiTrust Logo")
              # span(class: "self-center text-xl font-semibold sm:text-2xl whitespace-nowrap dark:text-white") { "Money" }
            end

            Form(action: current_tenant_path, method: "PATCH",
              class: "ml-8 w-56 flex items-center justify-center", data: { controller: "auto-submit" }) do
              Input(type: "hidden", name: "authenticity_token", value: view_context.form_authenticity_token)
              Remix::Store2Line(class: "w-6 h-6")
              Select do
                SelectInput(name: "branch_id", value: view_context.current_branch.id.to_s, id: "select-a-branch")
                SelectTrigger(variant: :ghost) do
                  SelectValue(placeholder: view_context.current_branch.name, id: "select-a-branch")
                end
                SelectContent(outlet_id: "select-a-branch") do
                  Branch.all.select(:id, :name).each do |branch|
                    SelectItem(
                      value: branch.id.to_s,
                      class: "cursor-pointer",
                      data: {
                        action: "click->auto-submit#submit",
                        ruby_ui__select_item_selected_value: view_context.current_branch.id.to_s
                      }) do
                      branch.name
                    end
                  end
                end
              end
            end
          end
          div(class: "flex items-center") do
            # div(class: "hidden mr-3 -mb-1 sm:block") { span }
            # button(id: "toggleSidebarMobileSearch", type: "button", class: "p-2 text-gray-500 rounded-lg lg:hidden hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white") do
            #   span(class: "sr-only") { "Search" }
            #   Remix::SearchLine(class: "w-6 h-6")
            # end
            button(type: "button", data_dropdown_toggle: "notification-dropdown", class: "relative p-2 text-gray-500 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700") do
              span(class: "sr-only") { "View notifications" }
              Remix::AlarmWarningLine(class: "w-6 h-6", data_action: "click->app#redirectToUrl", data_url: contracts_reminders_path)
              if view_context.current_branch.reminders_count.positive?
                div(class: "absolute inline-flex items-center justify-center w-5 h-5 text-xs font-bold text-white bg-red-500 border-2 border-white rounded-full -top-1 -right-1 dark:border-gray-900") do
                  view_context.current_branch.reminders_count
                end
              end
            end
            # div(class: "z-20 z-50 hidden max-w-sm my-4 overflow-hidden text-base list-none bg-white divide-y divide-gray-100 rounded shadow-lg dark:divide-gray-600 dark:bg-gray-700", id: "notification-dropdown", data_popper_placement: "bottom", style: "position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate3d(1333px, 65px, 0px);") do
            #   div(class: "block px-4 py-2 text-base font-medium text-center text-gray-700 bg-gray-50 dark:bg-gray-700 dark:text-gray-400") { "Notifications" }
            #   div do
            #     # ...notification items...
            #   end
            #   a(href: "#", class: "block py-2 text-base font-normal text-center text-gray-900 bg-gray-50 hover:bg-gray-100 dark:bg-gray-700 dark:text-white dark:hover:underline") do
            #     div(class: "inline-flex items-center") do
            #       Remix::EyeLine(class: "w-5 h-5")
            #       "View all"
            #     end
            #   end
            # end

            div(class: "flex items-center ml-3") do
              div do
                button(type: "button", class: "flex text-sm bg-gray-800 rounded-full focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600", id: "user-menu-button-2", aria_expanded: "false", data_dropdown_toggle: "dropdown-2") do
                  span(class: "sr-only") { "Open user menu" }
                  img(class: "w-8 h-8 rounded-full", src: @current_user.avatar, alt: "user photo")
                end
              end
              div(class: "z-50 my-4 text-base list-none bg-white divide-y divide-gray-100 rounded shadow dark:bg-gray-700 dark:divide-gray-600 hidden", id: "dropdown-2", aria_hidden: "true", data_popper_placement: "bottom", style: "position: absolute; inset: 0px auto auto 0px; margin: 0px; transform: translate3d(1461px, 61px, 0px);") do
                div(class: "px-4 py-3", role: "none") do
                  p(class: "text-sm text-gray-900 dark:text-white", role: "none") { @current_user.full_name }
                  p(class: "text-sm font-medium text-gray-900 truncate dark:text-gray-300", role: "none") { @current_user.email }
                end
                ul(class: "py-1", role: "none") do
                  li { button_to I18n.t("nav.sign_out"), sign_out_path, method: :delete, class: "w-full block px-4 py-2 text-left cursor-pointer text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white" }
                end
              end
            end
          end
        end
      end
    end
  end

  private

  def render_left_section
    div(class: "flex items-center justify-start") do
      render_mobile_sidebar_toggle
      render_logo
      render_search_form
    end
  end

  def render_mobile_sidebar_toggle
    button(
      id: "toggleSidebarMobile",
      aria_expanded: "true",
      aria_controls: "sidebar",
      class: "p-2 text-gray-600 rounded cursor-pointer lg:hidden hover:text-gray-900 hover:bg-gray-100 focus:bg-gray-100 dark:focus:bg-gray-700 focus:ring-2 focus:ring-gray-100 dark:focus:ring-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white",
      data_action: "click->navigation#toggleSidebar"
    ) do
      Remix::MenuLine(id: "toggleSidebarMobileHamburger", class: "w-6 h-6")
      Remix::CloseLine(id: "toggleSidebarMobileClose", class: "hidden w-6 h-6")
    end
  end

  def render_logo
    a(href: "/", class: "flex ml-2 md:mr-24") do
      img(
        src: "https://flowbite-admin-dashboard.vercel.app/images/logo.svg",
        class: "h-8 mr-3",
        alt: "FlowBite Logo"
      )
      span(class: "self-center text-xl font-semibold sm:text-2xl whitespace-nowrap dark:text-white") { "Plei Trust" }
    end
  end

  def render_search_form
    form(action: "#", method: "GET", class: "hidden lg:block lg:pl-3.5") do
      label(for: "topbar-search", class: "sr-only") { "Search" }
      div(class: "relative mt-1 lg:w-96") do
        div(class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
          Remix::SearchLine(class: "w-5 h-5 text-gray-500 dark:text-gray-400")
        end
        input(
          type: "text",
          name: "email",
          id: "topbar-search",
          class: "bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500",
          placeholder: "Search"
        )
      end
    end
  end

  def render_right_section
    div(class: "flex items-center") do
      div(class: "hidden mr-3 -mb-1 sm:block") { span }
      render_mobile_search_button
      render_notifications_dropdown
      render_apps_dropdown
      render_theme_toggle
      render_user_dropdown
    end
  end

  def render_mobile_search_button
    button(
      id: "toggleSidebarMobileSearch",
      type: "button",
      class: "p-2 text-gray-500 rounded-lg lg:hidden hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
    ) do
      span(class: "sr-only") { "Search" }
      Remix::SearchLine(class: "w-6 h-6")
    end
  end

  def render_notifications_dropdown
    div(class: "relative") do
      button(
        type: "button",
        class: "p-2 text-gray-500 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700",
        data_action: "click->dropdown#toggle"
      ) do
        span(class: "sr-only") { "View notifications" }
        Remix::Notification3Line(class: "w-6 h-6")
      end
      render_notifications_dropdown_content
    end
  end

  def render_notifications_dropdown_content
    div(
      class: "hidden z-20 max-w-sm my-4 overflow-hidden text-base list-none bg-white divide-y divide-gray-100 rounded shadow-lg dark:bg-gray-700 dark:divide-gray-600",
      data_dropdown_target: "menu"
    ) do
      div(class: "block px-4 py-2 text-base font-medium text-center text-gray-700 bg-gray-50 dark:bg-gray-700 dark:text-gray-400") do
        "Notifications"
      end
      div do
        render_notification_item(
          "Bonnie Green",
          "https://flowbite-admin-dashboard.vercel.app/images/users/bonnie-green.png",
          "New message from Bonnie Green: \"Hey, what's up? All set for the presentation?\"",
          "a few moments ago"
        ) { Remix::Chat1Line(class: "w-3 h-3 text-white") }
        render_notification_item(
          "Jese leos",
          "https://flowbite-admin-dashboard.vercel.app/images/users/jese-leos.png",
          "Jese leos and 5 others started following you.",
          "10 minutes ago"
        ) { Remix::UserAddLine(class: "w-3 h-3 text-white") }
      end
      a(href: "#", class: "block py-2 text-base font-normal text-center text-gray-900 bg-gray-50 hover:bg-gray-100 dark:bg-gray-700 dark:text-white dark:hover:underline") do
        div(class: "inline-flex items-center") do
          Remix::EyeLine(class: "w-5 h-5 mr-2")
          "View all"
        end
      end
    end
  end

  def render_notification_item(name, avatar, message, time, &icon)
    a(href: "#", class: "flex px-4 py-3 border-b hover:bg-gray-100 dark:hover:bg-gray-600 dark:border-gray-600") do
      div(class: "flex-shrink-0") do
        img(class: "rounded-full w-11 h-11", src: avatar, alt: "#{name} image")
        div(class: "absolute flex items-center justify-center w-5 h-5 ml-6 -mt-5 border border-white rounded-full bg-primary-700 dark:border-gray-700", &icon)
      end
      div(class: "w-full pl-3") do
        div(class: "text-gray-500 font-normal text-sm mb-1.5 dark:text-gray-400") { message }
        div(class: "text-xs font-medium text-primary-700 dark:text-primary-400") { time }
      end
    end
  end

  def render_apps_dropdown
    div(class: "relative") do
      button(
        type: "button",
        class: "hidden p-2 text-gray-500 rounded-lg sm:flex hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700",
        data_action: "click->dropdown#toggle"
      ) do
        span(class: "sr-only") { "View apps" }
        Remix::LayoutGridFill(class: "w-6 h-6")
      end
      render_apps_dropdown_content
    end
  end

  def render_apps_dropdown_content
    div(
      class: "hidden z-20 max-w-sm my-4 overflow-hidden text-base list-none bg-white divide-y divide-gray-100 rounded shadow-lg dark:bg-gray-700 dark:divide-gray-600",
      data_dropdown_target: "menu"
    ) do
      div(class: "block px-4 py-2 text-base font-medium text-center text-gray-700 bg-gray-50 dark:bg-gray-700 dark:text-gray-400") do
        "Apps"
      end
      div(class: "grid grid-cols-3 gap-4 p-4") do
        render_app_item("Sales", "#") { Remix::ShoppingBagLine(class: "mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400") }
        render_app_item("Users", "#") { Remix::UserLine(class: "mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400") }
        render_app_item("Inbox", "#") { Remix::InboxLine(class: "mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400") }
      end
    end
  end

  def render_app_item(name, href, &icon)
    a(href: href, class: "block p-4 text-center rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600") do
      icon&.call
      div(class: "text-sm font-medium text-gray-900 dark:text-white") { name }
    end
  end

  def render_theme_toggle
    button(
      id: "theme-toggle",
      type: "button",
      class: "text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm p-2.5",
      data_action: "click->navigation#toggleTheme"
    ) do
      Remix::MoonLine(id: "theme-toggle-dark-icon", class: "w-5 h-5")
      Remix::SunLine(id: "theme-toggle-light-icon", class: "hidden w-5 h-5")
    end
  end

  def render_user_dropdown
    div(class: "relative") do
      button(
        type: "button",
        class: "flex text-sm bg-gray-800 rounded-full focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600",
      ) do
        span(class: "sr-only") { "Open user menu" }
        img(class: "w-8 h-8 rounded-full", src: @user_avatar, alt: "user photo")
      end
      render_user_dropdown_content
    end
  end

  def render_user_dropdown_content
    div(
      class: "hidden z-50 my-4 text-base list-none bg-white divide-y divide-gray-100 rounded shadow dark:bg-gray-700 dark:divide-gray-600",
      data_dropdown_target: "menu"
    ) do
      div(class: "px-4 py-3", role: "none") do
        p(class: "text-sm text-gray-900 dark:text-white", role: "none") { @user_name }
        p(class: "text-sm font-medium text-gray-900 truncate dark:text-gray-300", role: "none") { @user_email }
      end
      ul(class: "py-1", role: "none") do
        li { a(href: "#", class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white", role: "menuitem") { "Dashboard" } }
        li { a(href: "#", class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white", role: "menuitem") { "Settings" } }
        li { a(href: "#", class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white", role: "menuitem") { "Earnings" } }
        li { a(href: "#", class: "block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600 dark:hover:text-white", role: "menuitem") { "Sign out" } }
      end
    end
  end
end
