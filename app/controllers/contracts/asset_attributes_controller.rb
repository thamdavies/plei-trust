class Contracts::AssetAttributesController < ContractsController
  def show
    run(AssetSetting::Operations::Show) do |result|
      asset_setting = result[:model]

      ctx = PawnContract::Operations::Create::Present.call
      @form = ctx[:"contract.default"]
      @form.contract_type_code = ContractType.codes[:pawn]
      @form.asset_setting_values = build_asset_setting_values(asset_setting)
    end
  end

  private

  def build_asset_setting_values(asset_setting)
    return [] unless asset_setting

    asset_setting.asset_setting_attributes.map do |attr|
      asset_setting_value = attr.asset_setting_value || attr.build_asset_setting_value(
        contract_id: @form&.id,
        asset_setting_attribute: attr,
        asset_setting_attribute_id: attr.id,
        value: ""
      )

      asset_setting_value
    end
  end
end
