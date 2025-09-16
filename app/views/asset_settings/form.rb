class Views::AssetSettings::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    div(class: "bg-white") do
      div(class: "w-full p-4 space-y-8 sm:p-4 bg-white dark:bg-gray-800") do
        Form(action: form_url, method: form_method) do
          Input(type: "hidden", name: "authenticity_token", value: view_context.form_authenticity_token)
          div(class: "flex gap-2") do
            Remix::Information2Line(class: "w-6 h-6")
            h2(class: "text-md mb-2 text-gray-900 dark:text-white") { "Nhập thông tin hàng hóa" }
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

          div(class: "flex gap-2 mt-4") do
            Remix::PassValidLine(class: "w-6 h-6")
            h2(class: "text-md mb-2 text-gray-900 dark:text-white") { "Cấu hình giá trị mặc định" }
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

            div(class: 'flex items-center space-x-3 mt-4') do
              Checkbox(id: 'collect_interest_in_advance', name: 'form[collect_interest_in_advance]', checked: form.collect_interest_in_advance)
              label(for: 'collect_interest_in_advance', class: 'text-sm cursor-pointer font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70') { "Thu lãi trước" }
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
end
