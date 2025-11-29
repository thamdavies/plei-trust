module ContractReminder::Contracts
  class Create < ApplicationContract
    property :contract_id
    property :date, populator: ->(options) {
      self.date = self.input_params["date"].parse_date_vn if self.input_params["date"].present?
    }
    property :note

    validation contract: DryContract do
      option :form

      params do
        required(:date).filled
      end

      rule(:date) do
        if value < Date.current
          key.failure("Ngày hẹn không được nhỏ hơn ngày hiện tại")
        end
      end
    end
  end
end
