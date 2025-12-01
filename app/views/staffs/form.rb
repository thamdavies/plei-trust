class Views::Staffs::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    Form(action: form_url, method: form_method) do
      Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      DialogHeader do
        DialogTitle { form.model.new_record? ? "Thêm nhân viên mới" : "Chỉnh sửa nhân viên" }
      end
      DialogMiddle do
        FormField do
          FormFieldLabel { "Email" }
          Input(
            type: "email", placeholder: "Nhập email", name: "form[email]", value: form.email,
            data: {
              type_mismatch: "Địa chỉ email không hợp lệ"
            }
          )
          FormFieldError() { form.errors[:email].first }
        end
        FormField do
          FormFieldLabel { "Mật khẩu" }
          Input(type: "password", placeholder: "Nhập mật khẩu", name: "form[password]", value: form.password)
          FormFieldError() { form.errors[:password].first }
        end
        FormField do
          FormFieldLabel { "Mật khẩu xác nhận" }
          Input(type: "password", placeholder: "Nhập mật khẩu xác nhận", name: "form[password_confirmation]", value: form.password_confirmation)
          FormFieldError() { form.errors[:password_confirmation].first }
        end
        FormField do
          FormFieldLabel { "Tên nhân viên" }
          Input(placeholder: "Nhập tên nhân viên", name: "form[full_name]", value: form.full_name)
          FormFieldError() { form.errors[:full_name].first }
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
          FormFieldError() { form.errors[:phone].first }
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
          FormFieldError() { form.errors[:status].first }
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

  def form_url
    if form.model.new_record?
      staffs_path
    else
      staff_path(form.model)
    end
  end
end
