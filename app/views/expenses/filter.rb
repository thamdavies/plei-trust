class Views::Expenses::Filter < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: form_url, method: "GET", class: "sm:pr-3 space-y-6") do |f|
            div(class: "flex items-center gap-4") do
              Remix::MenuSearchLine(class: "w-6 h-6")

              FormField(class: "relative w-48") do
                SearchInput(
                  name: "q[party_name_cont]",
                  placeholder: "Tìm theo tên KH",
                  value: view_context.params.dig(:q, :party_name_cont)
                )
              end
              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[transaction_date_gteq]",
                  label: "",
                  id: "start_date",
                  placeholder: "Từ ngày",
                  value: view_context.params.dig(:q, :transaction_date_gteq)
                )
              end
              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[transaction_date_lteq]",
                  label: "",
                  id: "end_date",
                  placeholder: "Đến ngày",
                  value: view_context.params.dig(:q, :transaction_date_lteq)
                )
              end
              div(class: "flex gap-4 items-center") do
                FormField(class: "w-sm") do
                  select(
                    name: "q[transaction_type_code_eq]",
                    id: "select-transaction-type-code",
                    placeholder: "Chọn loại phiếu",
                    data: { controller: "slim-select",
                      "slim-select-target": "select",
                      "slim-select-selected-value": view_context.params.dig(:q, :transaction_type_code_eq)
                    }) do
                    option(value: "", selected: view_context.params.dig(:q, :transaction_type_code_eq).blank?) { "Tất cả loại phiếu" }
                    view_context.select_options_for_transaction_types(is_income: income?).each do |item|
                      option(value: item.code, selected: item.code == view_context.params.dig(:q, :transaction_type_code_eq)) { item.name }
                    end
                  end
                end
              end

              Button(type: "submit") { "Tìm kiếm" }
            end
          end
        end
      end
    end
  end

  def income?
    false
  end

  def form_url
    expenses_path
  end
end
