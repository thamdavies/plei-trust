class Views::Shared::Contracts::AssetFormFields < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    div(class: "flex gap-4") do
      FormField(class: "min-w-sm relative") do
        FormFieldLabel { "Loại tài sản" }
        select(
          name: "form[asset_setting_id]",
          readonly: !form.can_edit_contract,
          disabled: !form.can_edit_contract,
          id: "select-asset-type",
          placeholder: "Chọn loại tài sản",
          data: { controller: "slim-select",
            "slim-select-target": "select",
            "shared--contract_target": "assetTypeSelect",
            "slim-select-selected-value": form.asset_setting_id,
            action: "change->shared--contract#handleAssetTypeChange"
          }) do
          view_context.select_options_for_asset_types.each do |asset_type|
            option(value: asset_type.id, selected: asset_type.id == form.asset_setting_id) { asset_type.name }
          end
        end
        FormFieldError() { form.errors[:asset_setting_id].first }
      end

      FormField(class: "min-w-sm") do
        FormFieldLabel { "Tên tài sản" }
        Input(
          placeholder: "Nhập tên tài sản",
          name: "form[asset_name]",
          value: form.asset_name,
          data: { "shared--contract_target": "assetNameInput" }
        )
        FormFieldError() { form.errors[:asset_name].first }
      end
    end
  end

  private

  attr_reader :form
end
