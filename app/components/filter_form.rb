class Components::FilterForm < Components::Base
  def initialize(filter_form)
    @filter_form = filter_form
  end

  def view_template
    case @filter_form
    when :customer
      customer_filter_form
    else
      raise "Unknown filter form: #{@filter_form}"
    end
  end

  private

  def customer_filter_form
    div(class: "flex justify-between w-full") do
      div(class: "w-full") do
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
          Form(action: "#", method: "GET", class: "sm:pr-3 space-y-6") do |f|
            div(class: "flex items-center gap-4") do
              Remix::UserSearchLine(class: "w-6 h-6")
              div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(id: "all", name: :status, checked: true)
                  FormFieldLabel(for: "all") { "Xem tất cả" }
                end

                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(id: "active", name: :status, checked: false)
                  FormFieldLabel(for: "active") { "Hoạt động" }
                end

                div(class: "flex items-center space-x-2 ml-3") do
                  RadioButton(id: "inactive", name: :status, checked: false)
                  FormFieldLabel(for: "inactive") { "Đã khoá" }
                end
              end
              FormField(class: "relative w-48 mt-1 sm:w-64 xl:w-96") do
                SearchInput(placeholder: I18n.t("placeholders.search_customers"), required: true, minlength: "3") { "Joel Drapper" }
              end
            end
          end
        end
      end
      div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
        Button(data: { app_dialog_target: "customer-dialog-trigger", action: "click->app#triggerDialog" }) { I18n.t("button.new") }
      end
    end
  end
end