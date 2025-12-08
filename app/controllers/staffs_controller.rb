# frozen_string_literal: true

class StaffsController < ApplicationController
  def index
    run(Staff::Operations::Index, current_user:, current_branch:) do |result|
      @q = result["q"]
      @pagy, staffs = pagy(result["model"])
      @staffs = staffs.decorate
    end

    run(Staff::Operations::Create::Present) do |result|
      @form = result["contract.default"]
    end

    add_breadcrumb("Quản lý nhân viên", :staffs_path)
  end

  def show
    @staff = User.find(params[:id])
  end

  def new
    run(Staff::Operations::Create::Present) do |result|
      @form = result[:"contract.default"]
    end
  end

  def create
    ctx = Staff::Operations::Create.call(params: permit_params.to_h)
    if ctx.success?
      flash[:success] = "Tạo mới nhân viên thành công"
      redirect_to(staffs_path)
    else
      @form = ctx[:"contract.default"]
      if ctx[:model].errors[:password].any?
        flash.now[:error] = ctx[:model].errors[:password].first
      end
    end
  end

  def edit
    run(Staff::Operations::Update::Present) do |result|
      @form = result[:"contract.default"]
    end
  end

  def update
    ctx = Staff::Operations::Update.call(params: permit_params.merge(id: params[:id]).to_h)
    if ctx.success?
      flash[:success] = "Cập nhật nhân viên thành công"
      redirect_to(staffs_path)
    else
      @form = ctx[:"contract.default"]
      if ctx[:model].errors[:password].any?
        flash.now[:error] = ctx[:model].errors[:password].first
      end
    end
  end

  def destroy
    run(Staff::Operations::Destroy) do |ctx|
      flash[:success] = "Xóa nhân viên thành công"
      redirect_to(staffs_path)
    end
  end

  private

  def permit_params
    params
      .require(:form)
      .permit(
        :email,
        :full_name,
        :phone,
        :password,
        :password_confirmation,
        :status
      ).merge(branch_id: current_branch.id)
  end
end
