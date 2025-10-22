module ReducePrincipal::Contracts
  class Cancel < ApplicationContract
    property :id # ID of financial transaction to cancel
    property :contract_id

    validation contract: DryContract do
      option :form

      params do
        required(:contract_id).filled(:string)
        required(:id).filled(:string)
      end

      rule(:id) do
        contract = ::Contract.find(form.contract_id)
        transaction = contract.financial_transactions.find(value)
        if transaction.transaction_type.code != TransactionType::PRINCIPAL_PAYMENT
          key.failure("giao dịch không phải là rút bớt gốc")
        else
          last_interest_payment = contract.paid_interest_payments.last
          if last_interest_payment && transaction.transaction_date < last_interest_payment.to
            key.failure("không thể hủy giao dịch rút bớt gốc trước kỳ lãi đã thanh toán cuối cùng")
          end
        end
      end
    end
  end
end
