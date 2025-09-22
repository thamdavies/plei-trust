module AssetSetting::Operations
  class Update < ApplicationOperation
    class Present < ApplicationOperation
      step Model(AssetSetting, :find)
      step :preprocess_params
      step Contract::Build(constant: AssetSetting::Contracts::Create)

      def preprocess_params(ctx, params:, **)
        if params[:asset_setting_categories].blank?
          params[:asset_setting_categories] = [ { "contract_type_id" => "" } ]
        end

        true
      end
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
