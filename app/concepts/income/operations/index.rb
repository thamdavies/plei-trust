module Income::Operations
  class Index < ApplicationOperation
    step :format_date
    step :filter
    step :sort

    # parse date from string "dd/MM/yyy" to date object "yyyy-MM-dd"
    # so that ransack can filter it correctly
    # for example: "01/01/2024" -> "2024-01-01"
    def format_date(ctx, params:, **)
      q_params = params[:q] || {}

      if q_params[:transaction_date_gteq].present?
        begin
          q_params[:transaction_date_gteq] = Date.strptime(q_params[:transaction_date_gteq], "%d/%m/%Y").to_s
        rescue ArgumentError
          q_params.delete(:transaction_date_gteq)
        end
      end

      if q_params[:transaction_date_lteq].present?
        begin
          q_params[:transaction_date_lteq] = Date.strptime(q_params[:transaction_date_lteq], "%d/%m/%Y").to_s
        rescue ArgumentError
          q_params.delete(:transaction_date_lteq)
        end
      end

      ctx[:q_params] = q_params

      true
    end

    def filter(ctx, q_params:, current_branch:, **)
      ctx[:model] = current_branch.financial_transactions
                                  .joins(:transaction_type)
                                  .where(transaction_types: { code: TransactionType::INCOME_TYPES })
                                  .ransack(q_params).result
    end

    def sort(ctx, params:, model:, **)
      ctx[:model] = model.order(id: :desc)
    end
  end
end
