module AssetSetting::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(AssetSetting, :new)
      step :preprocess_params
      step Contract::Build(constant: AssetSetting::Contracts::Create)

      def preprocess_params(ctx, params:, **)
        if params[:asset_setting_categories].blank?
          params[:asset_setting_categories] = [ { "contract_type_id" => "" } ]
        end

        true
      end
    end

    step Wrap(AppTransaction) {
      step Subprocess(Present)
      step Contract::Validate()
      step Contract::Persist()
    }
  end
end
