module ExtendTerm::Contracts
  class Update < ApplicationContract
    property :contract_id
    property :number_of_days, populator: ->(options) {
      self.number_of_days = self.input_params["number_of_days"].to_i if self.input_params["number_of_days"].present?
    }

    property :note

    validation contract: DryContract do
      params do
        required(:number_of_days).filled(:int?, gt?: 0)
        required(:contract_id).filled(:string)
      end

      rule(:contract_id) do
        contract = ::Contract.find_by(id: value)
        if contract.nil?
          key.failure(:not_found)
        else
          key.failure(:cannot_extend) if contract.capital?
        end
      end
    end
  end
end
