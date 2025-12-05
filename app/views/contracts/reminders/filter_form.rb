class Views::Contracts::Reminders::FilterForm < Views::Base
  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: contracts_reminders_path, method: "GET", class: "sm:pr-3 space-y-6", data: { controller: "auto-submit" }) do |f|
            div(class: "flex items-center gap-4") do
              Remix::MenuSearchLine(class: "w-6 h-6")

              FormField(class: "relative w-sm") do
                Select do
                  SelectInput(name: "q[contract_contract_type_code_eq]", value: view_context.params.dig(:q, :contract_contract_type_code_eq), id: "select-a-contract-type")
                  SelectTrigger(variant: :ghost) do
                    selected_status = view_context.select_options_for_contract_types_with_all_option.find { |status| status.code == view_context.params.dig(:q, :contract_contract_type_code_eq) }&.name || "Tất cả loại hợp đồng"
                    SelectValue(placeholder: selected_status, id: "select-a-contract-type")
                  end
                  SelectContent(outlet_id: "select-a-contract-type") do
                    view_context.select_options_for_contract_types_with_all_option.each do |item|
                      SelectItem(
                        value: item.code,
                        class: "cursor-pointer",
                        data: {
                          action: "click->auto-submit#submit",
                          ruby_ui__select_item_selected_value: view_context.params.dig(:q, :contract_contract_type_code_eq)
                        }) do
                        item.name
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
