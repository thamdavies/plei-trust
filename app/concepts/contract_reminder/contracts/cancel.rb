module ContractReminder::Contracts
  class Cancel < ApplicationContract
    property :contract_id

    validation contract: DryContract do
      option :form

      params do
        required(:contract_id).filled(:string)
      end
    end
  end
end
