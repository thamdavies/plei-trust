class CustomersController < ApplicationController
  before_action :require_login

  add_breadcrumb "Khách hàng", :customers_path

  def index
    add_breadcrumb "Danh sách", :customers_path

    run(Customer::Operations::Index, current_user:, current_branch:) do |result|
      @customers = result[:model]
      create_ctx = Customer::Operations::Create::Present.call
      @form = create_ctx[:"contract.default"]
    end
  end

  def new
    run(Customer::Operations::Create::Present) do |result|
      @form = result["contract.default"]
    end
  end

  def edit
    run(Customer::Operations::Update::Present) do |result|
      @form = result["contract.default"]
    end
  end

  def create
    ctx = Customer::Operations::Create.call(params: permit_params.to_h)
    if ctx.success?
      flash[:notice] = "Khách hàng đã được thêm"
      redirect_to customers_path
    else
      @form = ctx[:"contract.default"]
    end
  end

  def update
    ctx = Customer::Operations::Update.call(params: permit_params.to_h)
    if ctx.success?
      flash[:notice] = "Khách hàng đã được cập nhật"
      redirect_to customers_path
    else
      @form = ctx[:"contract.default"]
    end
  end

  private

  def permit_params
    params
      .require(:form)
      .permit(
        :id,
        :full_name,
        :phone,
        :national_id,
        :national_id_issued_date,
        :national_id_issued_place,
        :address,
        :status
      ).merge(
        created_by_id: current_user.id,
        branch_id: current_user.branch_id
      )
  end
end
