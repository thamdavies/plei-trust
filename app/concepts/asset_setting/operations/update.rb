module AssetSetting::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(AssetSetting, :find)
      step :preprocess_params
      step Contract::Build(constant: AssetSetting::Contracts::Create)

      def preprocess_params(ctx, params:, **)
        if params[:asset_setting_categories].blank?
          params[:asset_setting_categories] = [ { "contract_type_code" => "" } ]
        end

        true
      end
    end

    step Wrap(AppTransaction) {
      step Subprocess(Present)
      step Contract::Validate()
      step :handle_nested_destroy
      step Contract::Persist()
    }

    def handle_nested_destroy(ctx, model:, params:, **)
      attributes_params = params[:asset_setting_attributes_attributes]

      if attributes_params.present?
        attributes_params.each do |index, attr_params|
          if attr_params["_destroy"] == "1" && attr_params["id"].present?
            # Find and destroy the attribute
            attribute = model.asset_setting_attributes.find_by(id: attr_params["id"])
            attribute.destroy if attribute
          end
        end
      end

      true
    end
  end
end
