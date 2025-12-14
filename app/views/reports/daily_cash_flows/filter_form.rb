class Views::Reports::DailyCashFlows::FilterForm < Views::Base
  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: reports_daily_cash_flows_path, method: "GET", class: "sm:pr-3 space-y-6", data: { controller: "auto-submit" }) do |f|
            div(class: "flex items-center gap-4") do
              Remix::MenuSearchLine(class: "w-6 h-6")

              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[contract_date_gteq]",
                  label: "",
                  id: "start_date",
                  placeholder: "Từ ngày",
                  value: view_context.params.dig(:q, :contract_date_gteq)
                )
              end
              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[contract_date_lteq]",
                  label: "",
                  id: "end_date",
                  placeholder: "Đến ngày",
                  value: view_context.params.dig(:q, :contract_date_lteq)
                )
              end

              Button(type: "submit") { "Tìm kiếm" }
            end
          end
        end
      end
    end
  end
end
