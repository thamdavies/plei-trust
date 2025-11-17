class Contracts::CapitalsController < ContractsController
  before_action :set_contract, only: [ :update ]

  add_breadcrumb "Quản lý nguồn vốn", :contracts_capitals_path

  def index
    add_breadcrumb "Danh sách", :contracts_capitals_path

    run(CapitalContract::Operations::Index, current_user:, current_branch:) do |result|
      @pagy, contracts = pagy(result[:model])
      @contracts = contracts.decorate
      ctx = CapitalContract::Operations::Create::Present.call
      @form = ctx[:"contract.default"]
      @form.interest_calculation_method_obj = interest_calculation_method_obj
    end
  end

  def new
    ctx = CapitalContract::Operations::Create::Present.call
    @form = ctx[:"contract.default"]
    @form.interest_calculation_method_obj = interest_calculation_method_obj
    @form.contract_type_code = ContractType.codes[:capital]
  end

  def create
    ctx = CapitalContract::Operations::Create.call(params: permit_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash[:notice] = "Tạo mới hợp đồng nguồn vốn thành công"
      redirect_to(contracts_capitals_path)
    else
      @form = ctx[:"contract.default"]
      @form.prepopulate!(customer:)
      @form.interest_calculation_method_obj = interest_calculation_method_obj
    end
  end

  def edit
    run(CapitalContract::Operations::Update::Present) do |result|
      @form = result[:"contract.default"]
      @form.loan_amount = @form.loan_amount.to_f * 1000
      @form.interest_rate = @form.interest_rate.to_f
      @form.interest_calculation_method_obj = interest_calculation_method_obj
      @form.can_edit_contract = @form.model.can_edit_contract?
    end
  end

  def update
    authorize @contract, :update?

    ctx = CapitalContract::Operations::Update.call(params: update_params.to_h, current_user:, current_branch:)
    if ctx.success?
      flash[:notice] = "Cập nhật hợp đồng nguồn vốn thành công"
      redirect_to(contracts_capitals_path)
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
    run(CapitalContract::Operations::Show, id: params[:id]) do |result|
      @contract = result[:model].decorate
    end
  end

  private

  def permit_params
    form_params = params.require(:form).permit(
      :customer_id,
      :loan_amount,
      :contract_date,
      :interest_calculation_method,
      :interest_rate,
      :interest_period,
      :contract_term,
      :note,
      :collect_interest_in_advance,
      customer: [
        :id,
        :full_name,
        :national_id,
        :phone,
        :national_id_issued_date,
        :national_id_issued_place,
        :address
      ]
    )

    # Merge created_by_id vào customer nếu có customer data
    if form_params[:customer].present?
      form_params[:customer].merge!(
        created_by_id: current_user.id,
        branch_id: current_branch.id
      )

      form_params[:customer].merge!(id: form_params[:customer_id]) if form_params[:customer_id].present?
    end

    # Merge contract level data
    form_params.merge!(
      created_by_id: current_user.id,
      branch_id: current_branch.id,
      cashier_id: current_user.id,
      contract_type_code: contract_type.id,
    )

    form_params
  end

  def contract_id
    params[:id]
  end

  def update_params
    permit_params.merge(id: params[:id])
  end

  def contract_type
    @contract_type ||= ContractType.capital.first
  end

  def customer
    @customer ||= Customer.find_by(id: permit_params[:customer_id]).presence || Customer.new(**assign_customer_to_form)
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
end
