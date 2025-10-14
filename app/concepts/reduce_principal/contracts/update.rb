module ReducePrincipal::Contracts
  class Update < ApplicationContract
    property :contract_id
    property :prepayment_date
    property :prepayment_amount, default: 0, populator: ->(options) {
      self.prepayment_amount = self.input_params["prepayment_amount"].remove_dots.to_f if self.input_params["prepayment_amount"].present?
    }
    property :note

    validation contract: DryContract do
      params do
        required(:prepayment_amount).filled(:float?, gt?: 0)
      end
    end
  end
end
