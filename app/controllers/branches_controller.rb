class BranchesController < ApplicationController
  add_breadcrumb "Chi nhánh", :branches_path

  def index
    add_breadcrumb "Danh sách", :branches_path

    run(Branch::Operations::Index, current_user:, current_branch:) do |result|
      @pagy, branches = pagy(result[:model])
      @branches = branches.decorate
      ctx = Branch::Operations::Create::Present.call
      @form = ctx[:"contract.default"]
    end
  end

  def new
    run(Branch::Operations::Create::Present) do |result|
      @form = result[:"contract.default"]
    end
  end

  def edit
    run(Branch::Operations::Update::Present) do |result|
      @form = result[:"contract.default"]
      @form.invest_amount = @form.invest_amount.to_i * 1000
    end
  end

  def create
    ctx = Branch::Operations::Create.call(params: permit_params.to_h)
    if ctx.success?
      flash[:notice] = "Chi nhánh đã được thêm"
      redirect_to branches_path
    else
      @form = ctx[:"contract.default"]
    end
  end

  def update
    ctx = Branch::Operations::Update.call(params: update_params.to_h)
    if ctx.success?
      flash[:notice] = "Chi nhánh đã được cập nhật"
      redirect_to branches_path
    else
      @form = ctx[:"contract.default"]
    end
  end

  private

  def permit_params
    params
      .require(:form)
      .permit(
        :name,
        :phone,
        :province_id,
        :ward_id,
        :address,
        :representative,
        :invest_amount,
        :status
      )
  end

  def update_params
    permit_params.merge(id: params[:id])
  end
end
