module AssetSetting::Operations
  class Create < ApplicationOperation
    class Present < ApplicationOperation
      step Model(AssetSetting, :new)
      step Contract::Build(constant: AssetSetting::Contracts::Create)
    end

    step Subprocess(Present)
    step Contract::Validate()
    step Contract::Persist()
  end
end
