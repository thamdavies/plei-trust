# frozen_string_literal: true

module Debt::Contracts
  class Create < ApplicationContract
    property :amount
    property :contract_id

    validation contract: DryContract do
      option :form
      params do
        required(:amount).filled
        required(:contract_id).filled
      end

      rule(:amount) do
        amount = value.remove_dots.to_d
        contract = ::Contract.find_by(id: form.contract_id)

        if contract.nil?
          key.failure("Hợp đồng không tồn tại")
        end

        if amount <= 100.to_d
          key.failure("phải lớn hơn 100 VNĐ")
        elsif amount > contract.total_paid_interest.to_d
          key.failure("phải nhỏ hơn hoặc bằng số tiền đã thanh toán")
        end
      end
    end
  end
end
