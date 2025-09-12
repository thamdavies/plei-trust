class Views::Customers::Form < Views::Base
  def initialize(form:, url: nil, method: :post)
    @form = form
    @url = url
    @method = method
  end

  def view_template
    Form(url: @url, method: @method) do
      Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      DialogHeader do
        DialogTitle { form.model.new_record? ? "Thêm khách hàng mới" : "Chỉnh sửa khách hàng" }
      end
      DialogMiddle do
        FormField do
          FormFieldLabel { "Tên khách hàng" }
          Input(placeholder: "Nhập tên khách hàng", name: "form[full_name]", value: form.full_name)
          FormFieldError() { @form.errors[:full_name].first }
        end

        FormField do
          FormFieldLabel { "Số điện thoại" }
          div(class: "grid w-full items-center gap-1.5 mb-0") do
            MaskedInput(
              data: { maska: "### ### #####" },
              class: "w-full",
              placeholder: "Nhập số điện thoại",
              name: "form[phone]",
              value: form.phone
            )
          end
          FormFieldError() { @form.errors[:phone].first }
        end

        FormField do
          FormFieldLabel { "Số CMND" }
          div(class: "grid w-full items-center gap-1.5") do
            MaskedInput(
              data: { maska: "#" * 30 },
              class: "w-full",
              placeholder: "Nhập số CMND",
              name: "form[national_id]",
              value: form.national_id
            )
          end
          FormFieldError() { @form.errors[:national_id].first }
        end

        render Components::Fields::DateField.new(
          name: "form[national_id_issued_date]",
          label: "Ngày cấp", id: "issue_date", error: @form.errors[:national_id_issued_date].first,
          name: "form[national_id_issued_date]",
          value: form.national_id_issued_date
        )

        FormField do
          FormFieldLabel { "Nơi cấp" }
          Input(placeholder: "Nhập nơi cấp", name: "form[national_id_issued_place]", value: form.national_id_issued_place)
          FormFieldError()
        end

        FormField do
          FormFieldLabel { "Địa chỉ" }
          Input(placeholder: "Nhập địa chỉ", name: "form[address]", value: form.address)
          FormFieldError()
        end

        FormField do
          FormFieldLabel(for: "active") { "Trạng thái" }
          div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-0 dark:divide-gray-700") do
            div(class: "flex items-center space-x-2") do
              RadioButton(id: "form-active", name: "form[status]", checked: form.status == "active", value: "active")
              FormFieldLabel(for: "form-active", class: "cursor-pointer") { "Hoạt động" }
            end

            div(class: "flex items-center space-x-2 ml-3") do
              RadioButton(id: "form-inactive", name: "form[status]", checked: form.status == "inactive", value: "inactive")
              FormFieldLabel(for: "form-inactive", class: "cursor-pointer") { "Đã khoá" }
            end
          end
          FormFieldError()
        end
      end
      DialogFooter do
        Button(variant: :outline, data: { action: "click->ruby-ui--dialog#dismiss" }) { I18n.t("button.close") }
        Button(type: "submit") { I18n.t("button.save") }
      end
    end
  end

  private

  attr_reader :form
end
