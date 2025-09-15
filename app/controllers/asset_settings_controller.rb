class AssetSettingsController < ApplicationController
  add_breadcrumb "Cấu hình hàng hóa", :asset_settings_path

  def index
    add_breadcrumb "Danh sách", :asset_settings_path
    run(AssetSetting::Operations::Index) do |result|
      @pagy, @asset_settings = pagy(result[:model])
    end
  end
end
