class Views::Reports::TransactionSummary::FilterForm < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "flex items-center gap-4 mb-3") do
          Button(variant: :outline, class: "flex items-center gap-2 bg-green cursor-pointer") do
            Remix::FileExcelLine(class: "w-5 h-5")
            plain "Excel"
          end
          Button(variant: :outline, class: "flex items-center gap-2 cursor-pointer", data: { action: "click->app#printPage" }) do
            Remix::PrinterLine(class: "w-5 h-5")
            plain "In"
          end
        end

        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: reports_transaction_summary_index_path, method: "GET", class: "sm:pr-3 space-y-6") do |f|
            div(class: "flex flex-col lg:flex-row lg:items-center gap-4") do
              Remix::MenuSearchLine(class: "hidden lg:block w-6 h-6")
              FormField(class: "relative w-full lg:w-48") do
                SearchInput(
                  name: "q[customer_name_cont]",
                  placeholder: "Mã HĐ, tên KH",
                  value: view_context.params.dig(:q, :customer_name_cont)
                )
              end
              FormField(class: "relative w-full lg:w-36") do
                render Components::Fields::DateField.new(
                  name: "q[transaction_date_gteq]",
                  label: "",
                  id: "start_date",
                  placeholder: "Từ ngày",
                  value: view_context.params.dig(:q, :transaction_date_gteq)
                )
              end
              FormField(class: "relative w-full lg:w-36") do
                render Components::Fields::DateField.new(
                  name: "q[transaction_date_lteq]",
                  label: "",
                  id: "end_date",
                  placeholder: "Đến ngày",
                  value: view_context.params.dig(:q, :transaction_date_lteq)
                )
              end
              div(class: "flex gap-4 items-center w-full lg:w-auto") do
                FormField(class: "w-full lg:w-48") do
                  select(
                    name: "q[transactable_type_code_eq]",
                    id: "select-transaction-category",
                    placeholder: "Tất cả loại hình",
                    data: { controller: "slim-select",
                      "slim-select-target": "select",
                      "slim-select-selected-value": view_context.params.dig(:q, :transactable_type_code_eq)
                    }) do
                    option(value: "", selected: view_context.params.dig(:q, :transactable_type_code_eq).blank?) { "Tất cả loại hình" }
                    view_context.select_options_for_transaction_categories.each do |item|
                      option(value: item.code, selected: item.code == view_context.params.dig(:q, :transactable_type_code_eq)) { item.name }
                    end
                  end
                end
              end
              div(class: "flex gap-4 items-center w-full lg:w-auto") do
                FormField(class: "w-full lg:w-48") do
                  select(
                    name: "q[transaction_by_id_eq]",
                    id: "select-staff",
                    placeholder: "Tất cả nhân viên",
                    data: { controller: "slim-select",
                      "slim-select-target": "select",
                      "slim-select-selected-value": view_context.params.dig(:q, :transaction_by_id_eq)
                    }) do
                    option(value: "", selected: view_context.params.dig(:q, :transaction_by_id_eq).blank?) { "Tất cả nhân viên" }
                    view_context.select_options_for_staffs.each do |item|
                      option(value: item.id, selected: item.id == view_context.params.dig(:q, :transaction_by_id_eq)) { item.name }
                    end
                  end
                end
              end

              Button(type: "submit", class: "w-full lg:w-auto") { "Tìm kiếm" }
            end
          end
        end
      end
    end
  end
end
