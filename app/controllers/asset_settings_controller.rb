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
      @form.interest_calculation_method = Settings.default_interest_calculation_method
    end
  end

  def create
    ctx = AssetSetting::Operations::Create.call(params: permit_params.to_h)
    if ctx.success?
      flash[:notice] = "Tạo mới hàng hóa thành công"
      redirect_to(asset_settings_path)
    else
      @form = ctx[:"contract.default"]
      render(:new)
    end
  end

  def edit
    add_breadcrumb "Chỉnh sửa", :edit_asset_setting_path
  end

  private

  def permit_params
    params.require(:form).permit(
      :asset_name,
      :asset_code,
      :asset_appraisal_fee,
      :asset_rental_fee,
      :contract_initiation_fee,
      :early_termination_fee,
      :management_fee,
      :default_loan_amount,
      :default_loan_duration_days,
      :default_interest_rate,
      :liquidation_after_days,
      :interest_period,
      :interest_calculation_method,
      :collect_interest_in_advance,
      :status,
      asset_setting_categories: [],
      asset_setting_attributes_attributes: [
        :id,
        :attribute_name,
        :_destroy
      ]
    )
  end
end
