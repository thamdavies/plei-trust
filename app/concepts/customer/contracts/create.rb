# frozen_string_literal: true

module Customer::Contracts
  class Create < ApplicationContract
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
        optional(:phone)
      end

      rule(:phone) do
        if value.present? && !Phonelib.valid?(value.gsub(/\s+/, ""))
          key.failure(:invalid_phone_number)
        end
      end
    end
  end
end
