class ApplicationOperation < Trailblazer::Operation
  # parse date from string "dd/MM/yyy" to date object "yyyy-MM-dd"
  # so that ransack can filter it correctly
  # for example: "01/01/2024" -> "2024-01-01"
  def format_created_date(ctx, params:, **)
    if params.dig(:q, :created_at_gteq).present?
      params[:q][:created_at_gteq] = Date.strptime(params[:q][:created_at_gteq], "%d/%m/%Y").to_s
    end
    if params.dig(:q, :created_at_lteq).present?
      params[:q][:created_at_lteq] = Date.strptime(params[:q][:created_at_lteq], "%d/%m/%Y").to_s
    end

    ctx[:params] = params
  end
end
