class Views::Shared::Contracts::AssetAttributeFields < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    form.asset_setting_values.each do |asset_setting_value|
      Input(type: "hidden", name: "form[asset_setting_values][][asset_setting_attribute_id]", value: asset_setting_value.asset_setting_attribute_id)
      div(class: "flex gap-4 py-2 px-4") do
        FormField(class: "min-w-sm") do
          FormFieldLabel { asset_setting_value.asset_setting_attribute&.attribute_name }
          Input(
            placeholder: "Nhập #{asset_setting_value.asset_setting_attribute&.attribute_name&.downcase}",
            name: "form[asset_setting_values][][value]",
            value: asset_setting_value.value
          )
          FormFieldError() { form.errors[:asset_setting_values].first }
        end
      end
    end
  end

  private

  attr_reader :form
end
