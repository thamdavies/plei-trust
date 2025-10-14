class Views::Shared::Customers::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  attr_reader :form

  def view_template
    div(
      id: "customer-wrapper",
      data: {
        controller: "autocomplete shared--customer",
        "autocomplete-query-param-value": "name",
        "autocomplete-url-value": view_context.autocomplete_customers_path
      }) do
      div(class: "flex gap-4") do
        FormField(class: "min-w-sm relative") do
          FormFieldLabel { "Tên KH" }
          div(class: "relative") do
            Input(
              placeholder: "Nhập tên KH",
              name: "form[customer][full_name]",
              value: form.customer&.full_name,
              readonly: form.customer_id.present?,
              data: {
                "disable-autocomplete": "true",
                autocomplete_target: "input",
                "shared--customer_target": "fullNameInput"
              }
            )

            span(
              class: "#{'hidden' if form.customer_id.blank?} text-sm cursor-pointer text-red-500 absolute top-2.5 right-1",
              data: { "shared--customer_target": "remover", action: "click->shared--customer#clearSelection" }
            ) do
              Remix::CloseLine(class: "w-4 h-4")
            end
          end
          ul(data: { autocomplete_target: "results" }, class: "absolute z-10 w-sm bg-white border border-gray-300 rounded-md shadow-lg mt-0 max-h-60 overflow-y-auto p-2 text-sm")

          Input(type: "hidden", name: "form[customer_id]", value: form.customer_id, data: {
            autocomplete_target: "hidden", "shared--customer_target": "customerIdInput"
          })
          FormFieldError() { form.errors[:"customer.full_name"].first }
        end

        FormField(class: "min-w-sm") do
          FormFieldLabel { "Số CCCD/Hộ chiếu" }
          Input(
            placeholder: "Nhập số CCCD/Hộ chiếu",
            name: "form[customer][national_id]",
            value: form.customer&.national_id,
            data: { "shared--customer_target": "nationalIdInput" }
          )
          FormFieldError() { form.errors[:"customer.national_id"].first }
        end
      end

      div(class: "flex gap-4") do
        FormField(class: "min-w-sm") do
          FormFieldLabel { "Số điện thoại" }
          Input(
            placeholder: "Nhập số điện thoại",
            name: "form[customer][phone]",
            value: form.customer&.phone,
            data: { "shared--customer_target": "phoneInput" }
          )
          FormFieldError() { form.errors[:"customer.phone"].first }
        end

        render Components::Fields::DateField.new(
          name: "form[customer][national_id_issued_date]",
          wrapper_class: "min-w-sm",
          label: "Ngày cấp", id: "national_id_issued_date",
          error: form.errors[:"customer.national_id_issued_date"].first,
          data: { "data-shared--customer_target": "issueDateInput" },
          value: form.customer&.national_id_issued_date
        )
      end

      div(class: "flex gap-4") do
        FormField(class: "min-w-sm") do
          FormFieldLabel { "Nơi cấp" }
          Input(
            placeholder: "Nhập nơi cấp",
            name: "form[customer][national_id_issued_place]",
            value: form.customer&.national_id_issued_place,
            data: { "shared--customer_target": "issuePlaceInput" }
          )
          FormFieldError() { form.errors[:"customer.national_id_issued_place"].first }
        end

        FormField(class: "min-w-sm") do
          FormFieldLabel { "Địa chỉ" }
          Input(
            placeholder: "Nhập địa chỉ",
            name: "form[customer][address]",
            value: form.customer&.address,
            data: { "shared--customer_target": "addressInput" }
          )
          FormFieldError() { form.errors[:"customer.address"].first }
        end
      end
    end
  end
end
