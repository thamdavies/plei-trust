# frozen_string_literal: true

module Debt::Contracts
  class Destroy < ApplicationContract
    property :amount
    property :contract_id

    validation contract: DryContract do
      params do
        required(:amount).filled
        required(:contract_id).filled
      end

      rule(:amount) do
        amount = value.remove_dots.to_d
        if amount <= 0.to_d
          key.failure("phải lớn hơn 0 VNĐ")
        end
      end
    end
  end
end
