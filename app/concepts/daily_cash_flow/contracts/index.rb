module DailyCashFlow::Contracts
  class Index < ApplicationContract
    property :date_gteq
    property :date_lteq

    validation contract: DryContract do
      option :form

      params do
        optional(:date_gteq)
        optional(:date_lteq)
      end

      rule(:date_gteq) do
        if value.present?
          start_date = value.parse_date_vn
          end_date = form.date_lteq.parse_date_vn if form.date_lteq.present?

          if end_date && start_date > end_date
            key.failure("Ngày bắt đầu phải trước hoặc bằng ngày kết thúc")
          end
        end
      end
    end
  end
end
