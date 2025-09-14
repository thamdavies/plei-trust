class Views::Customers::FilterForm < Views::Base
  def initialize(filter_form)
    @filter_form = filter_form
  end

  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: customers_path, method: "GET", class: "sm:pr-3 space-y-6", data: { controller: "auto-submit" }) do |f|
            div(class: "flex items-center gap-4") do
              Remix::UserSearchLine(class: "w-6 h-6")
              div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(
                    id: "all",
                    name: "q[status_eq]",
                    checked: view_context.params.dig(:q, :status_eq) == "all" || view_context.params.dig(:q, :status_eq).blank?,
                    value: "",
                    data: { action: "auto-submit#submit" }
                  )
                  FormFieldLabel(for: "all") { "Xem tất cả" }
                end

                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(
                    id: "active",
                    name: "q[status_eq]",
                    checked: view_context.params.dig(:q, :status_eq) == "active",
                    value: "active",
                    data: { action: "auto-submit#submit" }
                  )
                  FormFieldLabel(for: "active") { "Hoạt động" }
                end

                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(
                    id: "inactive",
                    name: "q[status_eq]",
                    checked: view_context.params.dig(:q, :status_eq) == "inactive",
                    value: "inactive",
                    data: { action: "auto-submit#submit" }
                  )
                  FormFieldLabel(for: "inactive") { "Đã khoá" }
                end
              end
              FormField(class: "relative w-48 mt-1 sm:w-64 xl:w-96") do
                SearchInput(
                  name: "q[phone_or_full_name_or_national_id_cont]",
                  placeholder: I18n.t("placeholders.search_customers"),
                  value: view_context.params.dig(:q, :phone_or_full_name_or_national_id_cont)
                )
              end

              Button(type: "submit", class: "") { "Tìm kiếm" }
            end
          end
        end
      end

      div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700",
        data: { controller: "resource", resource_path_value: new_customer_path, resource_dialogbutton_value: "customer-dialog-trigger" }) do
        Button(data: { action: "click->resource#triggerDialog" }) { I18n.t("button.new") }
      end
    end
  end
end
