module AssetSetting::Operations
  class Show < ApplicationOperation
    step Model(AssetSetting, :find)
  end
end
