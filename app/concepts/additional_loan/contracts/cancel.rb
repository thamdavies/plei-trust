module AdditionalLoan::Contracts
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
        if transaction.transaction_type.code != TransactionType::ADDITIONAL_LOAN
          key.failure("giao dịch không phải là vay thêm")
        else
          last_interest_payment = contract.paid_interest_payments.last
          if last_interest_payment && transaction.transaction_date < last_interest_payment.to
            key.failure("Giao dịch này không thể hủy vì ngày trả lãi cuối cùng lớn hơn ngày giao dịch này")
          end
        end
      end
    end
  end
end
