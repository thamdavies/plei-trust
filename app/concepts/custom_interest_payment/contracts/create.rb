module CustomInterestPayment::Contracts
  class Create < ApplicationContract
    property :from_date
    property :to_date
    property :days_count

    property :interest_amount, default: 0, populator: ->(options) {
      self.interest_amount = self.input_params["interest_amount"].remove_dots if self.input_params["interest_amount"].present?
    }
    property :other_amount, default: 0, populator: ->(options) {
      self.other_amount = self.input_params["other_amount"].remove_dots if self.input_params["other_amount"].present?
    }
    property :total_interest_amount, default: 0, populator: ->(options) {
      self.total_interest_amount = self.input_params["total_interest_amount"].remove_dots if self.input_params["total_interest_amount"].present?
    }
    property :customer_payment_amount, default: 0, populator: ->(options) {
      self.customer_payment_amount = self.input_params["customer_payment_amount"].remove_dots if self.input_params["customer_payment_amount"].present?
    }

    property :next_interest_date, virtual: true
    property :daily_interest_rate, virtual: true
    property :note

    validation contract: DryContract do
      option :form

      params do
        required(:from_date).filled(:string)
        required(:to_date).filled(:string)
        required(:days_count).filled(:string)
      end

      rule(:from_date) do
        if value.present? && !value.to_date_vn
          key.failure("không đúng định dạng")
        end

        if value.present? && form.to_date.present? && value.parse_date_vn > form.to_date.parse_date_vn
          key.failure("phải nhỏ hơn hoặc bằng Đến ngày")
        end
      end
    end
  end
end
