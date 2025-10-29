class Contracts::ExtendTermsController < ApplicationController
  def update
    ctx = ExtendTerm::Operations::Update.call(params: permit_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      @form = ctx["contract.default"]
    end

    @contract = ctx[:contract].decorate
  end

  def destroy
    ctx = ExtendTerm::Operations::Cancel.call(params: cancel_params.to_h, current_user:)
    if ctx.success?
      flash.now[:notice] = ctx[:message]
    else
      err_msg = ctx["contract.default"].errors.messages[:id].first || "Đã có lỗi xảy ra khi hủy gia hạn thêm"
      flash.now[:alert] = err_msg
    end

    @contract = ctx[:contract].decorate
  end

  private

  def permit_params
    params.require(:form).permit(:contract_id, :number_of_days, :note)
  end

  def cancel_params
    params.require(:form).permit(:contract_id).merge(id: params[:id])
  end
end
