class Views::Shared::Customers::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  attr_reader :form

  def view_template
    div(data: {
      controller: "autocomplete shared--customer",
      "autocomplete-query-param-value": "name",
      "autocomplete-url-value": view_context.autocomplete_customers_path }) do
      FormField(class: "max-w-xl") do
        FormFieldLabel(for: "active") { "Khách hàng" }
        div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-2 dark:divide-gray-700 mt-1") do
          div(class: "flex items-center space-x-2") do
            RadioButton(id: "new-customer", name: "form[customer_type]", checked: form.customer_type == "new", value: "new")
            FormFieldLabel(for: "new-customer", class: "cursor-pointer") { "KH mới" }
          end

          div(class: "flex items-center space-x-2 ml-3") do
            RadioButton(id: "old-customer", name: "form[customer_type]", checked: form.customer_type == "old", value: "old")
            FormFieldLabel(for: "old-customer", class: "cursor-pointer") { "KH cũ" }
          end
        end
        FormFieldError() { form.errors[:customer_type].first }
      end

      div(class: "flex gap-4") do
        FormField(class: "min-w-sm relative") do
          FormFieldLabel { "Tên KH" }
          div(class: "relative") do
            Input(
              placeholder: "Nhập tên KH",
              name: "form[customer][full_name]",
              value: form.customer&.full_name,
              data: { autocomplete_target: "input" }
            )

            span(
              class: "hidden text-sm cursor-pointer text-red-500 absolute top-2 right-1",
              data: { "shared--customer_target": "remover", action: "click->shared--customer#clearSelection" }
            ) do
              Remix::CloseLine(class: "w-4 h-4")
            end
          end
          ul(data: { autocomplete_target: "results" }, class: "absolute z-10 w-sm bg-white border border-gray-300 rounded-md shadow-lg mt-0 max-h-60 overflow-y-auto p-2 text-sm")

          Input(type: "hidden", name: "form[customer_id]", value: form.customer_id, data: { autocomplete_target: "hidden" })
          FormFieldError() { form.errors[:"customer.full_name"].first }
        end

        FormField(class: "min-w-sm") do
          FormFieldLabel { "Số CCCD/Hộ chiếu" }
          Input(placeholder: "Nhập số CCCD/Hộ chiếu", name: "form[asset_name]", value: form.asset_name)
          FormFieldError() { form.errors[:asset_name].first }
        end
      end

      div(class: "flex gap-4") do
        FormField(class: "min-w-sm") do
          FormFieldLabel { "Số điện thoại" }
          Input(placeholder: "Nhập số điện thoại", name: "form[asset_name]", value: form.asset_name)
          FormFieldError() { form.errors[:asset_name].first }
        end

        FormField(class: "min-w-sm") do
          FormFieldLabel { "Ngày cấp" }
          Input(placeholder: "Nhập ngày cấp", name: "form[asset_name]", value: form.asset_name)
          FormFieldError() { form.errors[:asset_name].first }
        end
      end

      div(class: "flex gap-4") do
        FormField(class: "min-w-sm") do
          FormFieldLabel { "Nơi cấp" }
          Input(placeholder: "Nhập nơi cấp", name: "form[asset_name]", value: form.asset_name)
          FormFieldError() { form.errors[:asset_name].first }
        end

        FormField(class: "min-w-sm") do
          FormFieldLabel { "Địa chỉ" }
          Input(placeholder: "Nhập địa chỉ", name: "form[asset_name]", value: form.asset_name)
          FormFieldError() { form.errors[:asset_name].first }
        end
      end
    end
  end
end
