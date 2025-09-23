class Views::Branches::Form < Views::Base
  def initialize(form:, url: nil, method: :post)
    @form = form
  end

  def view_template
    Form(action: form_url, method: form_method) do
      Input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)
      DialogHeader do
        DialogTitle { form.model.new_record? ? "Thêm chi nhánh mới" : "Chỉnh sửa chi nhánh" }
      end
      DialogMiddle do
        FormField do
          FormFieldLabel { "Tên chi nhánh" }
          Input(placeholder: "Nhập tên chi nhánh", name: "form[name]", value: form.name)
          FormFieldError() { form.errors[:name].first }
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

        div class: "max-w-xl" do
          FormFieldLabel { "Tỉnh/Thành phố" }
          Combobox do
            ComboboxTrigger placeholder: "Chọn tỉnh thành"

            ComboboxPopover do
              ComboboxSearchInput(placeholder: "Chọn tỉnh thành hoặc nhập tên")

              ComboboxList do
                ComboboxEmptyState { "Không tìm thấy" }

                ComboboxListGroup(label: "Danh sách tỉnh thành") do
                  Province.all.each do |province|
                    ComboboxItem do
                      ComboboxRadio(name: "form[province_id]", value: province.code, checked: province.code == form.province_id)
                      span { province.name }
                    end
                  end
                end
              end
            end
          end
          FormFieldError() { form.errors[:province_id].first }
        end

        div class: "max-w-xl" do
          FormFieldLabel { "Quận/Huyện" }
          Combobox do
            ComboboxTrigger placeholder: "Chọn quận huyện"

            ComboboxPopover do
              ComboboxSearchInput(placeholder: "Chọn quận huyện hoặc nhập tên")

              ComboboxList do
                ComboboxEmptyState { "Không tìm thấy" }

                ComboboxListGroup(label: "Danh sách quận huyện") do
                  Ward.limit(10).each do |ward|
                    ComboboxItem do
                      ComboboxRadio(name: "form[ward_id]", value: ward.code, checked: ward.code == form.ward_id)
                      span { ward.name }
                    end
                  end
                end
              end
            end
          end
          FormFieldError() { form.errors[:ward_id].first }
        end

        FormField do
          FormFieldLabel { "Địa chỉ" }
          Input(placeholder: "Nhập địa chỉ", name: "form[address]", value: form.address)
          FormFieldError() { form.errors[:address].first }
        end

        FormField do
          FormFieldLabel { "Người đại diện" }
          Input(placeholder: "Nhập người đại diện", name: "form[representative]", value: form.representative)
          FormFieldError() { form.errors[:representative].first }
        end

        FormField(class: "max-w-xl") do
          FormFieldLabel { "Số vốn đầu tư" }
          div(class: "relative") do
            MaskedInput(
              data: { maska_number_locale: "vi", maska_number_unsigned: true },
              placeholder: "Nhập số vốn đầu tư",
              name: "form[invest_amount]",
              value: form.invest_amount.to_i,
              class: "pr-10"
            )
            span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
          end

          p(class: "text-sm font-medium text-destructive") do
            form.errors[:invest_amount].first
          end
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
    form.model.new_record? ? branches_path : branch_path(form.model)
  end
end
