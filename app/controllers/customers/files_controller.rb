class Customers::FilesController < ContractsController
  def create
    ctx = CustomerFile::Operations::Create.call(params: files_params.to_h, current_user:)
    @customer = ctx[:customer].decorate

    if ctx.success?
      flash.now[:notice] = "Tệp đã được tải lên thành công"
    else
      @form = ctx[:"contract.default"]
      @form.files = @customer.blobs
      flash.now[:alert] = @form.errors[:files].any? ? @form.errors[:files].first : "Đã có lỗi xảy ra trong quá trình tải lên tệp"
    end
  end

  def destroy
    ctx = CustomerFile::Operations::Destroy.call(params: destroy_params.to_h, current_user:)

    if ctx.success?
      render json: { error: nil }, status: :ok
    else
      render json: { error: "Đã có lỗi xảy ra trong quá trình xoá file" }, status: :unprocessable_entity
    end
  end

  private

  def files_params
    params.require(:form).permit(:customer_id, files: [])
  end

  def destroy_params
    params.permit(:id)
  end
end
