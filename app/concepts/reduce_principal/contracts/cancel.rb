module ReducePrincipal::Contracts
  class Cancel < ApplicationContract
    property :contract_id
    property :financial_transaction_id

    validation contract: DryContract do
      params do
        required(:contract_id).filled(:string?)
        required(:financial_transaction_id).filled(:string?)
      end
    end
  end
end
