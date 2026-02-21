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

  # Formats date parameters from DD/MM/YYYY string format to ISO 8601 format (YYYY-MM-DD).
  #
  # This method traverses through the params hash using the provided keys and converts
  # any date strings found from the format "DD/MM/YYYY" to the standard Date string format.
  # Invalid dates are silently ignored.
  #
  # @param params [Hash] The parameters hash containing date values to format
  # @param keys [Array<Symbol, String, Array>] An array of keys or key paths to locate date values.
  #   Can be simple keys (Symbol/String) or arrays representing nested paths.
  #
  # @example With simple keys
  #   params = { start_date: "25/12/2023", end_date: "31/12/2023" }
  #   format_date_params!(params, [:start_date, :end_date])
  #   # params becomes { start_date: "2023-12-25", end_date: "2023-12-31" }
  #
  # @example With nested keys
  #   params = { user: { birth_date: "15/06/1990" } }
  #   format_date_params!(params, [[:user, :birth_date]])
  #   # params becomes { user: { birth_date: "1990-06-15" } }
  #
  # @return [void] Modifies the params hash in place
  #
  # @note Blank values are skipped without error
  # @note Invalid date formats are silently ignored and left unchanged
  def format_date_params!(params, keys)
    keys.each do |key|
      path = key.is_a?(Array) ? key : [ key ]
      value = params.dig(*path)

      next if value.blank?

      begin
        formatted_value = Date.strptime(value, "%d/%m/%Y").to_s

        target = params
        path[0...-1].each do |k|
          target = target[k]
        end
        target[path.last] = formatted_value if target.is_a?(Hash)
      rescue Date::Error
        Rails.logger.warn("Invalid date format for value: #{value}")
      end
    end
  end
end
