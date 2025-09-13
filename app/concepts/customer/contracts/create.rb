# frozen_string_literal: true

module Customer::Contracts
  class Create < ApplicationContract
    property :id
    property :full_name
    property :national_id
    property :phone
    property :national_id_issued_date
    property :national_id_issued_place
    property :address
    property :branch_id
    property :created_by_id
    property :status, default: "active"

    validation contract: DryContract do
      params do
        required(:full_name).filled
        required(:created_by_id).filled
        required(:branch_id).filled
        optional(:phone).value(max_size?: 50)
        optional(:national_id).value(max_size?: 10)
        optional(:national_id_issued_date)
        optional(:national_id_issued_place).value(max_size?: 255)
        optional(:address).value(max_size?: 255)
        optional(:status).value(included_in?: Customer.statuses.keys)
      end

      rule(:phone) do
        if value.present? && !Phonelib.valid?(value.gsub(/\s+/, ""))
          key.failure(:invalid_phone_number)
        end
      end
    end
  end
end
