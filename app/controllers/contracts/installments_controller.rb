class Contracts::InstallmentsController < ContractsController
  before_action :set_contract, only: [ :update ]

  add_breadcrumb "Hợp đồng trả góp", :contracts_installments_path

  def index
    add_breadcrumb "Danh sách", :contracts_installments_path

    run(InstallmentContract::Operations::Index, current_user:, current_branch:) do |result|
      @pagy, contracts = pagy(result[:model])
      @contracts = contracts.decorate
      ctx = InstallmentContract::Operations::Create::Present.call
      @form = ctx[:"contract.default"]
      @form.interest_calculation_method_obj = interest_calculation_method_obj
    end
  end

  def new
    ctx = InstallmentContract::Operations::Create::Present.call
    @form = ctx[:"contract.default"]
    @form.interest_calculation_method_obj = interest_calculation_method_obj
    @form.contract_type_code = ContractType.codes[:installment]
    @form.asset_setting_values = build_asset_setting_values(asset_setting)
  end

  def create
    ctx = InstallmentContract::Operations::Create.call(params: permit_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash[:notice] = "Tạo mới hợp đồng cầm đồ thành công"
      redirect_to(contracts_installments_path)
    else
      @form = ctx[:"contract.default"]
      @form.prepopulate!(customer:)
      @form.interest_calculation_method_obj = interest_calculation_method_obj
    end
  end

  def edit
    run(InstallmentContract::Operations::Update::Present) do |result|
      @form = result[:"contract.default"]
      @form.loan_amount = @form.loan_amount.to_f * 1000
      @form.interest_rate = @form.interest_rate.to_f
      @form.interest_calculation_method_obj = interest_calculation_method_obj
      @form.can_edit_contract = @form.model.can_edit_contract?
      @form.asset_setting_values = build_asset_setting_values(asset_setting)
    end
  end

  def update
    authorize @contract, :update?

    ctx = InstallmentContract::Operations::Update.call(params: update_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash[:notice] = "Cập nhật hợp đồng cầm đồ thành công"
      redirect_to(contracts_installments_path)
    else
      @form = ctx[:"contract.default"]
      @form.prepopulate!(customer:)
      @form.can_edit_contract = @form.model.can_edit_contract?
      @form.interest_calculation_method_obj = interest_calculation_method_obj
    end
  rescue Pundit::NotAuthorizedError
    handle_cannot_operate_on_ended_contract
  end

  def show
    run(InstallmentContract::Operations::Show, id: params[:id]) do |result|
      @contract = result[:model].decorate
    end
  end

  private

  def contract_id
    params[:id]
  end

  def update_params
    permit_params.merge(id: params[:id])
  end

  def contract_type_code
    ContractType.codes[:installment]
  end

  def customer
    @customer ||= Customer.find_by(id: permit_params[:customer_id]).presence || Customer.new(**assign_customer_to_form)
  end

  def asset_setting
    @asset_setting ||= (AssetSetting.find_by(id: @form.asset_setting_id) || AssetSetting.first)
  end

  def interest_calculation_method_obj
    @interest_calculation_method_obj ||= InterestCalculationMethod.find_by(code: @form.interest_calculation_method)
  end

  def assign_customer_to_form
    {
      full_name: permit_params.dig(:customer, :full_name),
      national_id: permit_params.dig(:customer, :national_id),
      phone: permit_params.dig(:customer, :phone),
      national_id_issued_date: permit_params.dig(:customer, :national_id_issued_date),
      national_id_issued_place: permit_params.dig(:customer, :national_id_issued_place),
      address: permit_params.dig(:customer, :address)
    }
  end

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
