class Views::Reports::DailyCashFlows::FilterForm < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: reports_daily_cash_flows_path, method: "GET", class: "sm:pr-3 space-y-6", data: { controller: "auto-submit" }) do |f|
            div(class: "flex items-center gap-4 mb-0") do
              Remix::MenuSearchLine(class: "w-6 h-6")

              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[date_gteq]",
                  label: "",
                  id: "start_date",
                  placeholder: "Từ ngày",
                  value: @form.date_gteq,
                )
              end
              FormField(class: "relative w-48") do
                render Components::Fields::DateField.new(
                  name: "q[date_lteq]",
                  label: "",
                  id: "end_date",
                  placeholder: "Đến ngày",
                  value: @form.date_lteq,
                  error: @form.errors[:date_lteq]&.first
                )
              end

              Button(type: "submit") { "Tìm kiếm" }
              Link(href: reports_daily_cash_flows_path, class: "text-blue-500 hover:underline px-1") { "Xóa bộ lọc" }
            end

            if @form.errors[:date_gteq].present?
              span(class: "ml-10 text-sm text-red-600") { @form.errors[:date_gteq]&.first }
            end
          end
        end
      end
    end
  end
end
