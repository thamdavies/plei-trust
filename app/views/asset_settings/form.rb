class Views::AssetSettings::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    div(class: "bg-white") do
      div(class: "w-full p-4 space-y-8 sm:p-4 bg-white dark:bg-gray-800") do
        view_context.simple_form_for(@form, as: :form, url: form_url, html: {
          data: {
            controller: "nested-form",
            nested_form_wrapper_selector_value: ".nested-form-wrapper"
          }
        }) do |f|
          div(class: "flex gap-2") do
            Remix::Information2Line(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Nhập thông tin hàng hóa" }
          end
          FormField(class: "max-w-xl") do
            FormFieldLabel { "Lĩnh vực" }
            select(
              name: "form[asset_setting_categories]",
              id: "select-contract-type",
              multiple: true,
              placeholder: "Chọn 1 hoặc nhiều lĩnh vực",
              data: { controller: "slim-select",
                'slim-select-target': "select",
                'slim-select-selected-value': form.asset_setting_categories.pluck(:id)
              }) do
              ContractType.with_assets.select(:id, :name).each do |contract_type|
                option(value: contract_type.id, selected: false) { contract_type.name }
              end
            end
            FormFieldError() { form.errors[:asset_setting_categories].first }
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel { "Mã hàng hóa" }
            Input(placeholder: "Nhập mã hàng hóa", name: "form[asset_code]", value: form.asset_code)
            FormFieldError() { form.errors[:asset_code].first }
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel { "Tên hàng hóa" }
            Input(placeholder: "Nhập tên hàng hóa", name: "form[asset_name]", value: form.asset_name)
            FormFieldError() { form.errors[:asset_name].first }
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel(for: "active") { "Trạng thái" }
            div(class: "items-center mb-3 sm:flex sm:divide-x sm:divide-gray-100 sm:mb-2 dark:divide-gray-700 mt-1") do
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

          Separator(class: "my-4 max-w-xl")
          div(class: "flex gap-2 mt-5") do
            Remix::PassValidLine(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Cấu hình giá trị mặc định" }
          end

          div(class: "flex gap-4 items-center") do
            FormField(class: "w-xl") do
              FormFieldLabel { "Hình thức lãi" }
              select(
                name: "form[interest_calculation_method]",
                id: "select-contract-type",
                placeholder: "Chọn hình thức lãi",
                data: { controller: "slim-select",
                  'slim-select-target': "select",
                  'slim-select-selected-value': form.interest_calculation_method
                }) do
                InterestCalculationMethod.all.each do |interest_method|
                  option(value: interest_method.code, selected: interest_method.code == form.interest_calculation_method) { interest_method.name }
                end
              end
              FormFieldError() { form.errors[:interest_calculation_method].first }
            end

            div(class: "flex items-center space-x-3 mt-4") do
              Checkbox(id: "collect_interest_in_advance", name: "form[collect_interest_in_advance]", checked: form.collect_interest_in_advance)
              label(for: "collect_interest_in_advance", class: "text-sm cursor-pointer font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70") { "Thu lãi trước" }
            end
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel { "Số tiền cầm" }
            div(class: "relative") do
              MaskedInput(
                data: { maska_number_locale: "vi", maska_number_unsigned: true },
                placeholder: "Nhập số tiền cầm",
                name: "form[default_loan_amount]",
                value: form.default_loan_amount,
                class: "pr-10"
              )
              span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "VNĐ" }
            end

            FormFieldError() { form.errors[:default_loan_amount].first }
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel { "Lãi suất" }
            div(class: "relative") do
              Input(
                type: "number",
                placeholder: "Nhập lãi suất",
                name: "form[default_interest_rate]",
                value: form.default_interest_rate,
                class: "pr-10",
                data: { controller: "number-input" }
              )
              span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") { "%/tháng" }
            end

            FormFieldError() { form.errors[:default_interest_rate].first }
          end

          div(class: "flex gap-4 items-center") do
            FormField(class: "w-xl") do
              FormFieldLabel { "Kỳ lãi" }
              Input(
                type: "number",
                placeholder: "Nhập kỳ lãi",
                name: "form[interest_period]",
                value: form.interest_period,
                class: "pr-10",
                data: { controller: "number-input" }
              )

              FormFieldError() { form.errors[:interest_period].first }
            end
            span(class: "text-sm text-gray-500 mt-5") { "(VD: 1 tháng đóng lãi 1 lần thì điền số 1)" }
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel { "Số ngày cầm" }
            Input(
              type: "number",
              data: { controller: "number-input" },
              placeholder: "Nhập số ngày cầm",
              name: "form[default_loan_duration_days]",
              value: form.default_loan_duration_days,
              class: "pr-10"
            )

            FormFieldError() { form.errors[:default_loan_duration_days].first }
          end

          FormField(class: "max-w-xl") do
            FormFieldLabel { "Thanh lý sau" }
            div(class: "relative") do
              Input(
                type: "number",
                placeholder: "15",
                name: "form[liquidation_after_days]",
                value: form.liquidation_after_days,
                class: "pr-10",
                data: { controller: "number-input" }
              )
              span(class: "absolute text-sm inset-y-0 right-0 flex items-center pr-3 text-gray-500") do
                "ngày quá hạn"
              end
            end

            FormFieldError() { form.errors[:liquidation_after_days].first }
          end

          Separator(class: "my-4 max-w-xl")
          div(class: "flex gap-2 mt-5") do
            Remix::FileSettingsLine(class: "w-6 h-6")
            h2(class: "text-md mb-2 font-medium text-gray-900 dark:text-white") { "Cấu hình thuộc tính hàng hóa" }
          end

          render_nested_attributes_section(f)

          Button(type: "submit", class: "mt-6") do
            span { form.model.new_record? ? "Tạo hàng hóa" : "Cập nhật hàng hóa" }
          end

          # Cancel button
          Link(variant: "ghost", href: asset_settings_path, class: "btn btn-ghost mt-6 ml-4") do
            "Huỷ"
          end
        end
      end
    end
  end

  private

  attr_reader :form

  def form_url
    form.model.new_record? ? asset_settings_path : asset_setting_path(form.model)
  end

  def form_method
    form.model.new_record? ? "post" : "patch"
  end

  def render_nested_attributes_section(f)
    # Template cho nested items (PHẢI đặt bên ngoài wrapper)
    tag(:template, data: { nested_form_target: "template" }) do
      view_context.capture do
        f.simple_fields_for :asset_setting_attributes, AssetSettingAttribute.new, child_index: "NEW_RECORD" do |attribute_fields|
          render_attribute_form_item(attribute_fields)
        end
      end
    end

    # Render existing nested items
    f.simple_fields_for :asset_setting_attributes do |attribute_fields|
      render_attribute_form_item(attribute_fields)
    end

    # Target element - new items sẽ được insert trước element này
    div(data: { nested_form_target: "target" })

    # Button thêm item mới (PHẢI đặt bên ngoài wrapper)
    div(class: "mt-4") do
      Button(
        type: "button",
        variant: "outline",
        data: { action: "nested-form#add" }
      ) do
        Remix::AddLine(class: "w-4 h-4 mr-2")
        span { "Thêm thuộc tính" }
      end
    end
  end

  def render_attribute_form_item(attribute_fields)
    div(
      class: "nested-form-wrapper bg-white",
      data: { new_record: "#{attribute_fields.object.new_record?}" }
    ) do
      div(class: "flex gap-2 items-center max-w-xl") do
        FormField(class: "flex-1") do
          FormFieldLabel { "Thuộc tính" }
          Input(
            placeholder: "Nhập tên thuộc tính",
            name: attribute_fields.object_name + "[attribute_name]",
            value: attribute_fields.object.attribute_name,
            class: "flex-1"
          )
          FormFieldError() { attribute_fields.object.errors[:attribute_name].first }
        end

        # Remove button
        Button(
          type: "button",
          variant: "ghost",
          size: "sm",
          class: "mt-5 text-red-600 hover:bg-red-50 hover:text-red-800 py-3 cursor-pointer",
          data: { action: "nested-form#remove" }
        ) do
          Remix::CloseLine(class: "w-4 h-4")
        end
      end

      attribute_fields.hidden_field(:_destroy)
    end
  end
end
