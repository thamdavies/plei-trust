class Views::AssetSettings::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    Form(action: form_url, method: form_method) do
      Input(type: "hidden", name: "authenticity_token", value: view_context.form_authenticity_token)
      select(
        name: "form[asset_setting_categories]",
        id: "select-contract-type",
        data: { controller: "slim-select",
          'slim-select-target': "select",
          'slim-select-selected-value': form.asset_setting_categories.pluck(:id).map(&:to_s)
        }) do
        option(value: "") { "Chọn lĩnh vực" }
        ContractType.with_assets.each do |contract_type|
          option(value: contract_type.id.to_s, selected: false) { contract_type.name }
        end
      end

      FormField do
        FormFieldLabel { "Tên hàng hóa" }
        Input(placeholder: "Nhập tên hàng hóa", name: "form[asset_name]", value: form.asset_name)
        FormFieldError() { form.errors[:asset_name].first }
      end

      FormField do
        FormFieldLabel { "Mã hàng hóa" }
        Input(placeholder: "Nhập mã hàng hóa", name: "form[asset_code]", value: form.asset_code)
        FormFieldError() { form.errors[:asset_code].first }
      end

      FormField do
        FormFieldLabel { "Tiền cầm" }
        Input(placeholder: "Nhập tiền cầm", name: "form[default_loan_amount]", value: form.default_loan_amount)
        FormFieldError() { form.errors[:default_loan_amount].first }
      end

      FormField do
        FormFieldLabel { "Lãi suất (%)" }
        Input(placeholder: "Nhập lãi suất", name: "form[default_interest_rate]", value: form.default_interest_rate)
        FormFieldError() { form.errors[:default_interest_rate].first }
      end

      FormField do
        FormFieldLabel { "Kỳ lãi (tháng)" }
        Input(placeholder: "Nhập kỳ lãi", name: "form[interest_period]", value: form.interest_period)
        FormFieldError() { form.errors[:interest_period].first }
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
