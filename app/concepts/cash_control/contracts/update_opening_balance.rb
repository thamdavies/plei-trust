module CashControl::Contracts
  class UpdateOpeningBalance < ApplicationContract
    property :amount, populator: ->(options) {
      self.amount = self.input_params["amount"].remove_dots if self.input_params["amount"].present?
    }

    validation contract: DryContract do
      option :form

      params do
        required(:amount).filled
      end

      rule(:amount) do
        if value && (value.to_d / 1000) > 100_000_000
          key.failure("không được vượt quá 100 tỷ đồng")
        end

        if value.present? && (value.to_d / 1000) < 0
          key.failure("phải lớn hơn hoặc bằng 0")
        end
      end
    end
  end
end
