module WithdrawPrincipal::Contracts
  class Update < ApplicationContract
    property :contract_id
    property :start_date
    property :transaction_date, populator: ->(options) {
      self.transaction_date = self.input_params["transaction_date"].parse_date_vn if self.input_params["transaction_date"].present?
    }
    property :withdrawal_amount, default: 0, populator: ->(options) {
      self.withdrawal_amount = self.input_params["withdrawal_amount"].remove_dots.to_f if self.input_params["withdrawal_amount"].present?
    }
    property :other_amount, default: 0, populator: ->(options) {
      self.other_amount = self.input_params["other_amount"].remove_dots.to_f if self.input_params["other_amount"].present?
    }

    property :note

    validation contract: DryContract do
      option :form

      params do
        required(:transaction_date).filled
      end
    end
  end
end
