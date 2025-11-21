class Pdfs::ContractsController < ContractsController
  layout "blank"

  def create
    ctx = PawnContract::Operations::PdfBuild.call(params: permit_params.to_h, current_user:)
    render json: { activity_id: ctx[:activity_id] }
  end

  def show
    ctx = PawnContract::Operations::PdfPrint.call(params: print_params.to_h, current_user:)
    @customer_info = ctx[:customer_info]
    @asset_info = ctx[:asset_info]
    @fee_info = ctx[:fee_info]
  end

  private

  def print_params
    params.permit(:id)
  end
end
