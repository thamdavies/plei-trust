class AssetSettingsController < ApplicationController
  add_breadcrumb "Cấu hình hàng hóa", :asset_settings_path

  def index
    add_breadcrumb "Danh sách", :asset_settings_path
    run(AssetSetting::Operations::Index) do |result|
      @pagy, @asset_settings = pagy(result[:model])
    end
  end

  def new
    add_breadcrumb "Thêm mới", :new_asset_setting_path
    run(AssetSetting::Operations::Create::Present) do |result|
      @form = result[:"contract.default"]
    end
  end

  def edit
    add_breadcrumb "Chỉnh sửa", :edit_asset_setting_path
  end
end
