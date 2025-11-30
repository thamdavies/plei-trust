module Expense::Contracts
  class Create < ApplicationContract
    property :party_name
    property :amount, populator: ->(options) {
      self.amount = self.input_params["amount"].remove_dots if self.input_params["amount"].present?
    }
    property :transaction_type_code
    property :transaction_note

    validation contract: DryContract do
      params do
        required(:party_name).filled
        required(:amount).filled
        required(:transaction_type_code).filled
        required(:transaction_note).filled
      end

      rule(:amount) do
        if value && (value.to_d / 1000) > 100_000_000
          key.failure("không được vượt quá 100 tỷ đồng")
        end

        if value.present? && (value.to_d / 1000) < 1
          key.failure("phải lớn hơn hoặc bằng 1.000 đồng")
        end
      end
    end
  end
end
