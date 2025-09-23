class Views::AssetSettings::FilterForm < Views::Base
  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: asset_settings_path, method: "GET", class: "sm:pr-3 space-y-6", data: { controller: "auto-submit" }) do |f|
            div(class: "flex items-center gap-4 mb-1") do
              Remix::MenuSearchLine(class: "w-6 h-6")
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
                  name: "q[asset_code_or_asset_name_cont]",
                  placeholder: "Tìm kiếm tên, mã hàng hóa...",
                  value: view_context.params.dig(:q, :asset_code_or_asset_name_cont)
                )
              end

              Button(type: "submit") { "Tìm kiếm" }
            end

            div(class: "flex items-center gap-4") do
              Remix::ServiceLine(class: "w-6 h-6")
              Select(class: "w-48") do
                SelectInput(name: "q[asset_setting_categories_contract_type_id_eq]", value: "", id: "select-contract-type")
                SelectTrigger(variant: :ghost) do
                  SelectValue(
                    placeholder: view_context.select_options_for_contract_types.find { |item| item.id == view_context.params.dig(:q, :asset_setting_categories_contract_type_id_eq) }&.name || "Tất cả lĩnh vực",
                    id: "select-contract-type"
                  )
                end
                SelectContent(outlet_id: "select-contract-type") do
                  SelectItem(
                    value: "",
                    class: "cursor-pointer",
                    data: {
                      action: "click->auto-submit#submit",
                      ruby_ui__select_item_selected_value: view_context.params.dig(:q, :asset_setting_categories_contract_type_id_eq)
                    }) do
                    "Tất cả lĩnh vực"
                  end
                  view_context.select_options_for_contract_types.each do |contract_type|
                    SelectItem(
                      value: contract_type.id,
                      class: "cursor-pointer",
                      data: {
                        action: "click->auto-submit#submit",
                        ruby_ui__select_item_selected_value: view_context.params.dig(:q, :asset_setting_categories_contract_type_id_eq)
                      }) do
                      contract_type.name
                    end
                  end
                end
              end
            end
          end
        end
      end

      div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
        Link(href: new_asset_setting_path, variant: :primary) { "Thêm mới" }
      end
    end
  end
end
