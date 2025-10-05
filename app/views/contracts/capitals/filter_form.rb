class Views::Contracts::Capitals::FilterForm < Views::Base
  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: contracts_capitals_path, method: "GET", class: "sm:pr-3 space-y-6", data: { controller: "auto-submit" }) do |f|
            div(class: "flex items-center gap-4") do
              Remix::MenuSearchLine(class: "w-6 h-6")

              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[created_at_gteq]",
                  label: "",
                  id: "start_date",
                  placeholder: "Từ ngày",
                  value: view_context.params.dig(:q, :created_at_gteq)
                )
              end
              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[created_at_lteq]",
                  label: "",
                  id: "end_date",
                  placeholder: "Đến ngày",
                  value: view_context.params.dig(:q, :created_at_lteq)
                )
              end
              FormField(class: "relative w-32") do
                Select do
                  SelectInput(name: "q[status_eq]", value: view_context.params.dig(:q, :status_eq), id: "select-a-status")
                  SelectTrigger(variant: :ghost) do
                    selected_status = view_context.select_options_for_capital_contract_statuses.find { |status| status.code == view_context.params.dig(:q, :status_eq) }&.name || "Tất cả"
                    SelectValue(placeholder: selected_status, id: "select-a-status")
                  end
                  SelectContent(outlet_id: "select-a-status") do
                    view_context.select_options_for_capital_contract_statuses.each do |status|
                      SelectItem(
                        value: status.code,
                        class: "cursor-pointer",
                        data: {
                          action: "click->auto-submit#submit",
                          ruby_ui__select_item_selected_value: view_context.params.dig(:form, :status)
                        }) do
                        status.name
                      end
                    end
                  end
                end
              end
              FormField(class: "relative w-48 sm:w-64 xl:w-96") do
                SearchInput(
                  name: "q[customer_full_name_or_customer_national_id_cont]",
                  placeholder: "Tìm kiếm theo tên, CCCD người góp vốn",
                  value: view_context.params.dig(:q, :customer_full_name_or_customer_national_id_cont)
                )
              end

              Button(type: "submit") { "Tìm kiếm" }
            end
          end
        end
      end

      div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700",
        data: { controller: "resource", resource_path_value: new_contracts_capital_path, resource_dialogbutton_value: "capital-dialog-trigger" }) do
        Button(class: "cursor-pointer", data: { action: "click->resource#triggerDialog" }) { I18n.t("button.new") }
      end
    end
  end
end
